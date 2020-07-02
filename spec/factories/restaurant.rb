# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name         { 'Restaurant Name' }
    facebook_url { 'https://www.facebook.com/pg/bistropiccobello/posts/?ref=page_internal' }
  end
end
