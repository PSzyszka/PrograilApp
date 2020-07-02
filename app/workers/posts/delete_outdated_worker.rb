# frozen_string_literal: true

module Posts
  class DeleteOutdatedWorker
    include Sidekiq::Worker

    def perform
      posts = Post.where('created_at < ?', Date.current.beginning_of_day)
      posts.each(&:destroy)
    end
  end
end
