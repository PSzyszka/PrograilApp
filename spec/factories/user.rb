# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name                  { 'user' }
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              { 'Password123' }
    password_confirmation { 'Password123' }
  end
end
