# frozen_string_literal: true

module Restaurants
  class DownloadPostWorker
    include Sidekiq::Worker

    def perform(restaurant_id, retry_attempt = 0)
      ::Restaurants::DownloadPostService.call(restaurant_id, retry_attempt)
    end
  end
end
