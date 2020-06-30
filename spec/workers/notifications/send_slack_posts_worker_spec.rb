# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Notifications::SendSlackPostsWorker, type: :worker do
  let(:user_restaurant)       { create(:user_restaurant) }
  let(:post)                  { create(:post, restaurant: user_restaurant.restaurant) }
  let(:scheduled_valid_job)   { Notifications::SendSlackPostsWorker.new.perform(post.id) }
  let(:scheduled_invalid_job) { Notifications::SendSlackPostsWorker.new.perform(post.id + 1) }

  describe '#perform' do
    context 'when post id is present' do
      it 'enqueues SendSlackPostsWorker' do
        expect { Notifications::SendSlackPostsWorker.perform_async }.to change(
          Notifications::SendSlackPostsWorker.jobs, :size
        ).by(1)
      end

      it 'schedules SendUserSlackPostWorker' do
        expect(Notifications::SendUserSlackPostWorker).to receive(:perform_async).
                                                       with(post.id, user_restaurant.user.id)
        scheduled_valid_job
      end
    end

    context 'when post id is absent' do
      it 'raises ActiveRecord::RecordNotFound error' do
        expect { scheduled_invalid_job }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
