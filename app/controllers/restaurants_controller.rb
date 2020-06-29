# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @restaurants = Restaurant.joins(user_restaurants: :user).
                              merge(User.where(id: current_user.id)).
                              order(:created_at)
  end

  def create
    ActiveRecord::Base.transaction do
      @restaurant = Restaurant.create!(restaurant_params)
      UserRestaurant.create!(restaurant: @restaurant, user: current_user)
    end

    redirect_to restaurants_path, success: I18n.t('restaurant.added_succesfully')
  rescue ActiveRecord::RecordInvalid => e
    redirect_to restaurants_path, alert: e.message
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to restaurants_path, alert: I18n.t('restaurant.not_found')
  end

  def update
    @restaurant = Restaurant.find(params[:id])

    @restaurant.update!(restaurant_params)
    redirect_to restaurants_path, success: I18n.t('restaurant.succesfully_updated')
  rescue ActiveRecord::RecordInvalid => e
    render 'edit', alert: e.message
  rescue ActiveRecord::RecordNotFound
    redirect_to restaurants_path, alert: I18n.t('restaurant.not_found')
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path, success: I18n.t('restaurant.was_deleted')
  rescue ActiveRecord::RecordNotFound
    redirect_to restaurants_path, alert: I18n.t('restaurant.not_found')
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :facebook_url)
  end
end
