# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::SendSlackPostService do
  let(:slack_channel) { create(:slack_channel) }
  let(:post)          { create(:post) }

  describe '#call' do
    context 'when slack channel and post are present' do
      it 'sends post description to slack channel' do
        notifier = double(:notifier, ping: nil)
        expect(Slack::Notifier).to receive(:new).and_return(notifier)
        expect(notifier).to receive(:ping).with("*#{post.restaurant.name.upcase}*\n#{post.description}")
        Notifications::SendSlackPostService.call(slack_channel, post)
      end
    end
  end
end
