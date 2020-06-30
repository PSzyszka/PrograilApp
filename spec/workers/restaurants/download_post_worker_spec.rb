# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Restaurants::DownloadPostWorker, type: :worker do
  let(:restaurant)    { create(:restaurant) }
  let(:scheduled_job) { Restaurants::DownloadPostWorker.new.perform(restaurant.id, 0) }

  describe '#perform' do
    it 'enqueues DownloadPostWorker' do
      expect { Restaurants::DownloadPostWorker.perform_async }.to change(
        Restaurants::DownloadPostWorker.jobs, :size
      ).by(1)
    end

    it 'executes DownloadPostService' do
      expect(Restaurants::DownloadPostService).to receive(:call).with(restaurant.id, 0)

      scheduled_job
    end
  end
end
