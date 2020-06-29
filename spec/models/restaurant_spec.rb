# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it 'has a valid factory' do
    restaurant = build(:restaurant)
    expect(restaurant).to be_valid
  end

  it 'is invalid without name or facebook url' do
    restaurant = build(:restaurant, name: nil)
    expect(restaurant).to be_invalid

    restaurant = build(:restaurant, facebook_url: nil)
    expect(restaurant).to be_invalid
  end

  it 'is invalid when not matching facebook url regex' do
    restaurant = build(:restaurant, facebook_url: 'https://www.facebook.com/prograils_app')
    expect(restaurant).to be_invalid
  end
end
