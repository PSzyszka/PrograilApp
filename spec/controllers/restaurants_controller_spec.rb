# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let!(:user)            { create(:user) }
  let!(:restaurant)      { create(:restaurant) }
  let!(:user_restaurant) { create(:user_restaurant, user: user, restaurant: restaurant) }
  let(:invalid_params)   { { restaurant: { name: 'Restaurant', facebook_url: '' } } }
  let(:valid_params) do
    {
      restaurant: {
        name: 'Restaurant',
        facebook_url: 'https://www.facebook.com/pg/bistropiccobello/posts/'
      }
    }
  end

  before(:each) { sign_in(user) }

  describe 'GET index' do
    it 'assigns restaurants to @restaurants and renders index template' do
      get :index
      expect(assigns(:restaurants)).to eq([restaurant])
      expect(response).to render_template(:index)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates restaurant and redirects to restaurants path' do
        expect { post :create, params: valid_params }.to change(Restaurant, :count).by(1)
        expect(response).to redirect_to(restaurants_path)
      end
    end

    context 'with invalid params' do
      it "doesn't create restaurant and redirects to restaurant path" do
        expect { post :create, params: invalid_params }.to change(Restaurant, :count).by(0)
        expect(response).to redirect_to(restaurants_path)
      end
    end
  end

  describe 'GET edit' do
    context 'when restaurant is present' do
      it 'assigns the requested restaurant as @restaurant and renders edit template' do
        valid_params[:id] = restaurant.id
        get :edit, params: valid_params
        expect(response).to render_template(:edit)
        expect(assigns(:restaurant)).to eq(restaurant)
      end
    end

    context 'when restaurant is absent' do
      it 'redirects to root path' do
        valid_params[:id] = restaurant.id + 1
        get :edit, params: valid_params
        expect(response).to redirect_to(restaurants_path)
      end
    end
  end

  describe 'PUT update' do
    context 'when restaurant is present' do
      context 'with valid params' do
        it 'updates restaurant and redirects to restaurants path' do
          valid_params[:id] = restaurant.id
          put :update, params: valid_params

          expect(response).to redirect_to(restaurants_path)
          expect(restaurant.reload.name).to eq('Restaurant')
        end
      end

      context 'with invalid params' do
        it "doesn't update restaurant and renders edit template" do
          invalid_params[:id] = restaurant.id
          put :update, params: invalid_params

          expect(response).to render_template(:edit)
          expect(restaurant.reload.name).to eq('Restaurant Name')
        end
      end
    end

    context 'when restaurant is absent' do
      it 'redirects to restaurants path' do
        valid_params[:id] = restaurant.id + 1
        put :update, params: valid_params

        expect(response).to redirect_to(restaurants_path)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when restaurant is present' do
      it 'destroyes the requested restaurant and redirects to restaurants path' do
        valid_params[:id] = restaurant.id
        expect { delete :destroy, params: valid_params }.to change(Restaurant, :count).by(-1)
        expect(response).to redirect_to(restaurants_path)
      end
    end

    context 'when restaurant is absent' do
      it 'redirects to restaurants path' do
        valid_params[:id] = restaurant.id + 1
        delete :destroy, params: valid_params

        expect(response).to redirect_to(restaurants_path)
      end
    end
  end
end
