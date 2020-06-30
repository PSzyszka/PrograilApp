# frozen_string_literal: true

module Restaurants
  class DownloadPostsWorker
    include Sidekiq::Worker

    def perform
      Restaurant.find_each do |restaurant|
        ::Restaurants::DownloadPostWorker.perform_async(restaurant.id)
      end
    end
  end
end
