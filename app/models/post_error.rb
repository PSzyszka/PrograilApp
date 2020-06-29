# frozen_string_literal: true

class PostError < ApplicationRecord
  validates :description, presence: true

  belongs_to :restaurant
end
