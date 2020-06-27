# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without name, email, password or password_confirmation' do
    user = build(:user, email: nil)
    expect(user).to be_invalid
  end

  it 'is invalid without a uniq email' do
    email = 'example@example.com'
    user = create(:user, email: email)
    second_user = build(:user, email: email)
    expect(user).to be_valid
    expect(second_user).to be_invalid
  end

  it 'is invalid with wrong email format' do
    email = 'example.example.com'
    user = build(:user, email: email)
    expect(user).to be_invalid
  end

  it 'is invalid with to long or to short name' do
    name = 'To long name to be valid for a user'
    user = build(:user, name: name)
    expect(user).to be_invalid

    name = 'I'
    user = build(:user, name: name)
    expect(user).to be_invalid
  end
end
