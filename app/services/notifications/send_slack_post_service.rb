# frozen_string_literal: true

module Notifications
  class SendSlackPostService
    def self.call(slack_channel, post)
      new.call(slack_channel, post)
    end

    def call(slack_channel, post)
      notifier = Slack::Notifier.new slack_channel.webhook_url do
        defaults channel: slack_channel.name,
                 username: slack_channel.user.name
      end

      description = add_restaurant_name(post)
      notifier.ping description
    end

    private

    def add_restaurant_name(post)
      "*#{post.restaurant.name.upcase}*\n#{post.description}"
    end
  end
end
