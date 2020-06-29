# frozen_string_literal: true

class Subscription < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  belongs_to :user
end
