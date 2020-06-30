# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Restaurants::DownloadPostsWorker, type: :worker do
  let(:restaurant)    { create(:restaurant) }
  let(:scheduled_job) { Restaurants::DownloadPostsWorker.new.perform }

  describe '#perform' do
    it 'enqueues DownloadPostsWorker' do
      expect { Restaurants::DownloadPostsWorker.perform_async }.to change(
        Restaurants::DownloadPostsWorker.jobs, :size
      ).by(1)
    end

    it 'schedules DownloadPostWorker' do
      expect(Restaurants::DownloadPostWorker).to receive(:perform_async).with(restaurant.id)
      scheduled_job
    end
  end
end
