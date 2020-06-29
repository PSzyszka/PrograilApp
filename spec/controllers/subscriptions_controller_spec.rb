# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user)           { create(:user) }
  let(:subscription)   { create(:subscription) }
  let(:valid_params)   { { subscription: { email: 'random@email.com', user_id: user.id } } }
  let(:invalid_params) { { subscription: { email: '', user_id: user.id } } }
  let(:confirm_email_params)           { { confirm_token: subscription.confirm_token } }
  let(:invalid_confirm_email_params)   { { confirm_token: '' } }

  before(:each) { sign_in(user) }

  describe 'GET new' do
    it 'assigns a new subscription as @subscription and renders new template' do
      get :new
      assigns(:subscription).should be_a_new(Subscription)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates subscription, renders new template and executes UserMailer' do
        confirm_subscription_email = double(:confirm_subscription_email, deliver_later: nil)
        mailer = double(:mailer, confirm_subscription_email: confirm_subscription_email)

        expect(UserMailer).to receive(:with).and_return(mailer)
        expect(confirm_subscription_email).to receive(:deliver_later)
        expect { post :create, params: valid_params }.to change(Subscription, :count).by(1)
        expect(response).to render_template(:new)
      end
    end

    context 'with invalid params' do
      it "doesn't create restaurant and redirects to restaurant path" do
        expect { post :create, params: invalid_params }.to change(Subscription, :count).by(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET confirm_email' do
    context 'when subscription is present' do
      it 'updates subscription and redirects to root path' do
        get :confirm_email, params: confirm_email_params

        expect(response).to redirect_to(root_path)
        expect(subscription.reload.email_confirmed).to eq(true)
      end
    end

    context 'when subscription is absent' do
      it 'redirects to root path' do
        expect(get :confirm_email, params: invalid_confirm_email_params).to redirect_to(root_path)
      end
    end
  end
end
