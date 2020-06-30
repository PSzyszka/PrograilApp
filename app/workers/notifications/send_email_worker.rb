# frozen_string_literal: true

module Notifications
  class SendEmailWorker
    include Sidekiq::Worker

    def perform(post_id)
      post = Post.includes(restaurant: { user_restaurants: { user: :subscriptions } }).
                  joins(restaurant: { user_restaurants: { user: :subscriptions } }).
                  merge(Subscription.where(email_confirmed: true)).
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
