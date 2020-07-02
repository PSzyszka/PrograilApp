# frozen_string_literal: true

module Notifications
  class SendEmailWorker
    include Sidekiq::Worker

    def perform(post_id)
      confirmed_subscriptions = Subscription.where(email_confirmed: true)
      return unless confirmed_subscriptions.any?

      post = Post.includes(restaurant: { user_restaurants: { user: :subscriptions } }).
                  joins(restaurant: { user_restaurants: { user: :subscriptions } }).
                  merge(confirmed_subscriptions).
                  find(post_id)

      post.users.each do |user|
        user.subscriptions.each do |subscription|
          SendUserNotificationMailer.with(subscription: subscription, post: post).
                                     notification_email.deliver_later
        end
      end
    end
  end
end
