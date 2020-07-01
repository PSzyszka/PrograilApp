# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  attr_accessible :encrypted_password

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true
  validates :name, length: { in: 2..30 }
  validates :email, format: { with: VALID_EMAIL_REGEX }

  has_many :subscriptions
  has_many :slack_channels
  has_many :user_restaurants
  has_many :restaurants, through: :user_restaurants
end
