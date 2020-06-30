# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Posts::DeleteOutdatedWorker, type: :worker do
  let!(:posts)        { create_list(:post, 2, created_at: 1.day.ago) }
  let(:scheduled_job) { Posts::DeleteOutdatedWorker.new.perform }

  describe '#perform' do
    it 'destroys posts that were created 1 day ago' do
      expect { scheduled_job }.to change(Post, :count).by(-2)
    end
  end
end
