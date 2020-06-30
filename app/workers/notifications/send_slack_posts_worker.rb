# frozen_string_literal: true

module Notifications
  class SendSlackPostsWorker
    include Sidekiq::Worker

    def perform(post_id)
      post = Post.includes(restaurant: { user_restaurants: :user }).find(post_id)
      post.users.each do |user|
        Notifications::SendUserSlackPostWorker.perform_async(post.id, user.id)
      end
    end
  end
end
