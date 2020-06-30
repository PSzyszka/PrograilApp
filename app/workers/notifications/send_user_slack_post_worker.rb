# frozen_string_literal: true

module Notifications
  class SendUserSlackPostWorker
    include Sidekiq::Worker

    def perform(post_id, user_id)
      post = Post.find(post_id)
      slack_channels = SlackChannel.where(user_id: user_id)
      slack_channels.each do |slack_channel|
        Notifications::SendSlackPostService.call(slack_channel, post)
      end
    end
  end
end
