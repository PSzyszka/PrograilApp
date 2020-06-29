# frozen_string_literal: true

class SlackChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    @slack_channels = SlackChannel.where(user_id: current_user.id)
  end

  def create
    @slack_channel = SlackChannel.new(slack_params)
    @slack_channel.save!
    redirect_to slack_channels_path, success: I18n.t('slack_channel.created_succesfully')
  rescue ActiveRecord::RecordInvalid => e
    redirect_to slack_channels_path, alert: e.message
  end

  def edit
    @slack_channel = SlackChannel.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to slack_channels_path, alert: I18n.t('slack_channel.not_found')
  end

  def update
    @slack_channel = SlackChannel.find(params[:id])

    @slack_channel.update!(slack_params)
    redirect_to slack_channels_path, success: I18n.t('slack_channel.succesfully_updated')
  rescue ActiveRecord::RecordInvalid => e
    render 'edit', alert: e.message
  rescue ActiveRecord::RecordNotFound
    redirect_to slack_channels_path, alert: I18n.t('slack_channel.not_found')
  end

  def destroy
    @slack_channel = SlackChannel.find(params[:id])
    @slack_channel.destroy
    redirect_to slack_channels_path, success: I18n.t('slack_channel.deleted_succesfully')
  rescue ActiveRecord::RecordNotFound
    redirect_to slack_channels_path, alert: I18n.t('slack_channel.not_found')
  end

  private

  def slack_params
    params.require(:slack_channel).permit(:name, :webhook_url, :user_id)
  end
end
