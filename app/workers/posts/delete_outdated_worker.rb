# frozen_string_literal: true

module Posts
  class DeleteOutdatedWorker
    include Sidekiq::Worker

    def perform
      posts = Post.where('created_at <= ?', 1.day.ago)
      posts.each(&:destroy)
    end
  end
end
