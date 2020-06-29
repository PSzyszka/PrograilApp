# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:user)            { create(:user) }
  let!(:restaurant)      { create(:restaurant) }
  let!(:user_restaurant) { create(:user_restaurant, user: user, restaurant: restaurant) }
  let!(:user_posts)      { create_list(:post, 3, restaurant: restaurant).sort }
  let!(:random_posts)    { create_list(:post, 2) }

  before(:each) { sign_in(user) }

  describe 'GET index' do
    it 'assigns posts to @posts and renders index template' do
      get :index
      expect(assigns(:posts)).to eq(user_posts)
      expect(response).to render_template(:index)
    end
  end
end
