# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    email           { '#general' }
    email_confirmed { false }
    confirm_token   { SecureRandom.urlsafe_base64.to_s }
    user

    trait :email_confirmed do
      email_confirmed { true }
    end
  end
end
