# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackChannelsController, type: :controller do
  let!(:user)                      { create(:user) }
  let(:slack_channel)              { create(:slack_channel, user: user) }
  let!(:random_user_slack_channel) { create(:slack_channel) }
  let(:invalid_params) do
    { slack_channel: { name: '#general', webhook_url: '', user_id: user.id } }
  end
  let(:valid_params) do
    {
      slack_channel: {
        name: '#posts',
        webhook_url: 'https://hooks.slack.com/services/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',
        user_id: user.id
      }
    }
  end

  before(:each) { sign_in(user) }

  describe 'GET index' do
    it 'assigns slack channels to @slack_channels and renders index template' do
      get :index
      expect(assigns(:slack_channels)).to eq([slack_channel])
      expect(response).to render_template(:index)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates slack channel and redirects to slack_channels path' do
        expect { post :create, params: valid_params }.to change(SlackChannel, :count).by(1)
        expect(response).to redirect_to(slack_channels_path)
      end
    end

    context 'with invalid params' do
      it "doesn't create restaurant and redirects to restaurant path" do
        expect { post :create, params: invalid_params }.to change(SlackChannel, :count).by(0)
        expect(response).to redirect_to(slack_channels_path)
      end
    end
  end

  describe 'GET edit' do
    context 'when slack channel is present' do
      it 'assigns the requested slack channel as @slack_channel and renders edit template' do
        valid_params[:id] = slack_channel.id
        get :edit, params: valid_params
        expect(response).to render_template(:edit)
        expect(assigns(:slack_channel)).to eq(slack_channel)
      end
    end

    context 'when slack channel is absent' do
      it 'redirects to root path' do
        valid_params[:id] = slack_channel.id + 1
        get :edit, params: valid_params
        expect(response).to redirect_to(slack_channels_path)
      end
    end
  end

  describe 'PUT update' do
    context 'when slack channel is present' do
      context 'with valid params' do
        it 'updates slack channel and redirects to slack channels path' do
          valid_params[:id] = slack_channel.id

          expect { put :update, params: valid_params }.
            to change { slack_channel.reload.name }.
            to('#posts')
          expect(response).to redirect_to(slack_channels_path)
        end
      end

      context 'with invalid params' do
        it "doesn't update slack channel and renders edit template" do
          invalid_params[:id] = slack_channel.id

          expect { put :update, params: invalid_params }.not_to change { slack_channel.reload.name }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when slack channel is absent' do
      it 'redirects to slack channels path' do
        valid_params[:id] = slack_channel.id + 1
        put :update, params: valid_params

        expect(response).to redirect_to(slack_channels_path)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when slack channel is present' do
      it 'destroyes the requested slack channel and redirects to slack channels path' do
        valid_params[:id] = slack_channel.id
        expect { delete :destroy, params: valid_params }.to change(SlackChannel, :count).by(-1)
        expect(response).to redirect_to(slack_channels_path)
      end
    end

    context 'when slack channel is absent' do
      it 'redirects to slack channels path' do
        valid_params[:id] = slack_channel.id + 1
        delete :destroy, params: valid_params

        expect(response).to redirect_to(slack_channels_path)
      end
    end
  end
end
