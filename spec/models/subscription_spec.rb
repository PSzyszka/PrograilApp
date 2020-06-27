# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it 'has a valid factory' do
    subscription = build(:subscription)
    expect(subscription).to be_valid
  end

  it 'is invalid without email' do
    subscription = build(:subscription, email: nil)
    expect(subscription).to be_invalid
  end

  it 'is invalid without a uniq email' do
    email = 'example@example.com'
    subscription = create(:subscription, email: email)
    second_subscription = build(:subscription, email: email)
    expect(subscription).to be_valid
    expect(second_subscription).to be_invalid
  end
end
