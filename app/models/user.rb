class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :name, :email, uniqueness: true
  validates :name, length: { in: 2..30 }
  validates :email, format: { with: VALID_EMAIL_REGEX }
end
