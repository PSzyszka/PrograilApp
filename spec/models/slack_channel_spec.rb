# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackChannel, type: :model do
  it 'has a valid factory' do
    slack_channel = create(:slack_channel)
    expect(slack_channel).to be_valid
  end

  it 'is invalid without name or facebook url' do
    slack_channel = build(:slack_channel, name: nil)
    expect(slack_channel).to be_invalid

    slack_channel = build(:slack_channel, webhook_url: nil)
    expect(slack_channel).to be_invalid
  end

  it 'is invalid when not matching facebook url or slack channel name regex' do
    invalid_webhook_url = 'https://www.facebook.com/prograils_app'
    slack_channel = build(:slack_channel, webhook_url: invalid_webhook_url)
    expect(slack_channel).to be_invalid

    invalid_name = 'general'
    slack_channel = build(:slack_channel, name: invalid_name)
    expect(slack_channel).to be_invalid
  end
end
