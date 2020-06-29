# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.joins(restaurant: { user_restaurants: :user }).
                 merge(User.where(id: current_user.id)).
                 order(:created_at)
  end
end
