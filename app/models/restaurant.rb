# frozen_string_literal: true

class Restaurant < ApplicationRecord
  BASE_RESTAURANT_URL_REGEX = %r{\W*(https:\/\/www.facebook.com\/).*\/posts\/\z}i.freeze

  validates :name, :facebook_url, presence: true
  validates :facebook_url, format: { with: BASE_RESTAURANT_URL_REGEX }

  has_many :posts
  has_many :post_errors
  has_many :user_restaurants
  has_many :users, through: :user_restaurants
end
