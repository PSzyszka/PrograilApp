# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, exept: :confirm_email
  before_action :check_confirmation_token, only: :update

  def new
    @subscription = Subscription.new
  end

  def create
    params_with_confirm_token = subscription_params.merge(confirm_token: confirm_token)
    subscription = Subscription.new(params_with_confirm_token)
    subscription.save!
    UserMailer.with(subscription: subscription).confirm_subscription_email.deliver_later
    render :new, success: I18n.t('subscription.please_confirm_your_email')
  rescue ActiveRecord::RecordInvalid => e
    render :new, alert: e.message
  end

  def confirm_email
    subscription = Subscription.find_by!(confirm_token: params[:confirm_token])
    subscription.update!(email_confirmed: true)
    redirect_to root_path, success: I18n.t('subscription.succesfully_updated')
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: I18n.t('subscription.not_found')
  end

  # TODO: create delete method to let user unsubscribe his email

  private

  def subscription_params
    params.require(:subscription).permit(:email, :email_confirmed, :confirm_token, :user_id)
  end

  def confirm_token
    SecureRandom.urlsafe_base64.to_s
  end
end
