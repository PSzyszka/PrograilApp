# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'has a valid factory' do
    post = build(:post)
    expect(post).to be_valid
  end

  it 'is invalid without description or restaurant id' do
    post = build(:post, description: nil)
    expect(post).to be_invalid

    post = build(:post, restaurant_id: nil)
    expect(post).to be_invalid
  end
end
