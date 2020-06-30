# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurants::DownloadPostService do
  let(:restaurant) { create(:restaurant) }

  describe '#call' do
    context 'when restaurant is present' do
      context 'when facebook url is valid' do
        it 'creates post and schedule notificaiton workers' do
          VCR.use_cassette 'services/restaurants/download_post_service' do
            expect(Notifications::SendEmailWorker).to receive(:perform_async)
            expect(Notifications::SendSlackPostsWorker).to receive(:perform_async)
            expect { Restaurants::DownloadPostService.call(restaurant.id) }.to change(Post, :count).by(1)
          end
        end
      end

      context 'when facebook url is invalid' do
        it 'creates post error' do
          VCR.use_cassette 'services/restaurants/download_not_existing_restaurant_url' do
            restaurant = create(
              :restaurant,
              facebook_url: 'https://www.facebook.com/pg/bistropiccobellotest/posts/'
            )

            expect(Notifications::SendEmailWorker).not_to receive(:perform_async)
            expect(Notifications::SendSlackPostsWorker).not_to receive(:perform_async)
            expect { Restaurants::DownloadPostService.call(restaurant.id) }.
              to change(PostError, :count).by(1)
          end
        end
      end

      context 'when net read timeout accours and retry_attempt is less than 3' do
        it 'schedules a worker to perform another download attempt' do
          allow(HTTParty).to receive(:get).and_raise(Net::ReadTimeout)

          expect(Notifications::SendEmailWorker).not_to receive(:perform_async)
          expect(Notifications::SendSlackPostsWorker).not_to receive(:perform_async)
          expect(Restaurants::DownloadPostWorker).to receive(:perform_in).with(
            5.minutes, restaurant.id, 3
          )
          Restaurants::DownloadPostService.call(restaurant.id, 2)
        end
      end

      context 'when net read timeout accours and retry_attempt is less than 0' do
        it 'creates post error' do
          allow(HTTParty).to receive(:get).and_raise(Net::ReadTimeout)

          expect(Notifications::SendEmailWorker).not_to receive(:perform_async)
          expect(Notifications::SendSlackPostsWorker).not_to receive(:perform_async)
          expect { Restaurants::DownloadPostService.call(restaurant.id, 3) }.
            to change(PostError, :count).by(1)
        end
      end
    end

    context 'when restaurant is absent' do
      it 'creates post error' do
        expect { Restaurants::DownloadPostService.call(restaurant.id + 1) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
