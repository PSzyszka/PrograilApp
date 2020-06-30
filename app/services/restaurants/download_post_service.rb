# frozen_string_literal: true

module Restaurants
  class DownloadPostService
    MAX_RETRY_ATTEMPTS = 3

    def self.call(restaurant_id, retry_attempt = 0)
      new.call(restaurant_id, retry_attempt)
    end

    def call(restaurant_id, retry_attempt = 0)
      restaurant = Restaurant.find(restaurant_id)
      parsed_restaurant_page = parse_url(restaurant.facebook_url)
      document = select_last_post(parsed_restaurant_page)
      description = remove_html_tags(document)
      post = Post.create!(description: description.to_s, restaurant: restaurant)
      schedule_notification_workers(post)
    rescue ActiveRecord::RecordNotFound
      raise
    rescue Net::ReadTimeout => e
      schedule_download_retry(restaurant, retry_attempt, e)
    rescue StandardError => e
      PostError.create!(description: e.message, restaurant: restaurant)
    end

    private

    def parse_url(url)
      unparsed_page = HTTParty.get(url)
      Nokogiri::HTML(unparsed_page)
    end

    def select_last_post(page)
      page.css('div.userContent').first.to_s
    end

    def remove_html_tags(document)
      doc = Nokogiri::HTML(document)
      doc.xpath('//script')&.remove
      doc.xpath('//style')&.remove
      doc.xpath('//text()').map(&:text).join(' ').squish
    end

    def schedule_download_retry(restaurant, retry_attempt, error)
      if retry_attempt < MAX_RETRY_ATTEMPTS
        Restaurants::DownloadPostWorker.perform_in(5.minutes, restaurant.id, retry_attempt + 1)
      else
        PostError.create!(description: error.message, restaurant: restaurant)
      end
    end

    def schedule_notification_workers(post)
      Notifications::SendEmailWorker.perform_async(post.id)
      Notifications::SendSlackPostsWorker.perform_async(post.id)
    end
  end
end
