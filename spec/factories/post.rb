# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    description { 'Post description' }
    restaurant
  end
end
