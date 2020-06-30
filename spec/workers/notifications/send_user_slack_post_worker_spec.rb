# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Notifications::SendUserSlackPostWorker, type: :worker do
  let(:post)                  { create(:post) }
  let(:user)                  { create(:user) }
  let(:slack_channel)         { create(:slack_channel, user: user) }
  let(:scheduled_valid_job)   do
    Notifications::SendUserSlackPostWorker.new.perform(post.id, user.id)
  end

  let(:scheduled_invalid_job) do
    Notifications::SendUserSlackPostWorker.new.perform(post.id + 1, user.id)
  end

  describe '#perform' do
    context 'when post and user id are present' do
      it 'enqueues SendUserSlackPostWorker' do
        expect { Notifications::SendUserSlackPostWorker.perform_async }.to change(
          Notifications::SendUserSlackPostWorker.jobs, :size
        ).by(1)
      end

      it 'executes SendSlackPostService' do
        expect(Notifications::SendSlackPostService).to receive(:call).with(slack_channel, post)
        scheduled_valid_job
      end
    end

    context 'when post or user id are absent' do
      it 'raises ActiveRecord::RecordNotFound error' do
        expect { scheduled_invalid_job }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
