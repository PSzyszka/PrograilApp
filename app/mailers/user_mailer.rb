# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirm_subscription_email
    @confirm_token = params[:subscription].confirm_token
    mail(to: params[:subscription].email, subject: I18n.t('subscription.confirm'))
  end
end
