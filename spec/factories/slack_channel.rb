# frozen_string_literal: true

FactoryBot.define do
  factory :slack_channel do
    sequence(:name) { |n| "#general_#{n}" }
    webhook_url     { 'https://hooks.slack.com/services/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' }
    user
  end
end
