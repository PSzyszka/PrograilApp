# frozen_string_literal: true

class SendUserNotificationMailer < ApplicationMailer
  def notification_email
    @description = params[:post].description
    @restaurant_name = params[:post].restaurant.name
    mail(to: params[:subscription].email, subject: "#{@restaurant_name} today's offer")
  end
end
