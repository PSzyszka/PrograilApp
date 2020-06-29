# frozen_string_literal: true

class Post < ApplicationRecord
  validates :description, presence: true

  belongs_to :restaurant
  has_many :user_restaurants, through: :restaurant
  has_many :users, through: :user_restaurants
end
