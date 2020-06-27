# frozen_string_literal: true

class SlackChannel < ApplicationRecord
  SLACK_CHANNEL_REGEX = %r{/\#.*\z/i}.freeze
  BASE_WEEBHOOK_URL_REGEX = %r{
    /\W*(https:\/\/hooks.slack.com\/services\/)[a-zA-Z0-9]+\/[a-zA-Z0-9]+\/[a-zA-Z0-9]+\z/i
  }.freeze

  validates :name, :webhook_url, :user_id, presence: true
  validates :name, format: { with: SLACK_CHANNEL_REGEX }
  validates :webhook_url, format: { with: BASE_WEEBHOOK_URL_REGEX }

  belongs_to :user
end
