# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Notifications::SendEmailWorker, type: :worker do
  let!(:user_restaurant)       { create(:user_restaurant) }
  let!(:subscription)          { create(:subscription, :email_confirmed, user: user_restaurant.user) }
  let!(:post)                  { create(:post, restaurant: user_restaurant.restaurant) }
  let(:scheduled_valid_job)   { Notifications::SendEmailWorker.new.perform(post.id) }
  let(:scheduled_invalid_job) { Notifications::SendEmailWorker.new.perform(post.id + 1) }

  describe '#perform' do
    context 'when post id is present' do
      it 'enqueues SendEmailWorker' do
        expect { Notifications::SendEmailWorker.perform_async }.to change(
          Notifications::SendEmailWorker.jobs, :size
        ).by(1)
      end

      it 'executes SendUserNotificationMailer' do
        notification_email = double(:notification_email, deliver_later: nil)
        mailer = double(:mailer, notification_email: notification_email)

        expect(SendUserNotificationMailer).
          to receive(:with).
          with(subscription: subscription, post: post).
          and_return(mailer)

        expect(notification_email).to receive(:deliver_later)
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
