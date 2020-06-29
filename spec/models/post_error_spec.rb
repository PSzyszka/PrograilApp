# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostError, type: :model do
  it 'has a valid factory' do
    post_error = build(:post_error)
    expect(post_error).to be_valid
  end

  it 'is invalid without description or restaurant id' do
    post_error = build(:post_error, description: nil)
    expect(post_error).to be_invalid

    post_error = build(:post_error, restaurant_id: nil)
    expect(post_error).to be_invalid
  end
end
