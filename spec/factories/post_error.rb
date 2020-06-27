# frozen_string_literal: true

FactoryBot.define do
  factory :post_error do
    description { 'Post error description' }
    restaurant
  end
end
