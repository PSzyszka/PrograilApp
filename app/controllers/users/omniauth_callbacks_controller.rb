# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_filter :authenticate_user!

    def facebook
      result = Users::CreateFromOmniauthOrganizer.call(
        auth: request.env['omniauth.auth'],
        current_user: current_user
      )

      if result.success?
        flash[:notice] = t('login_modal.login_success')
        sign_in_and_redirect(result.user)
      else
        @user = result.user
        @authorization = result.authorization
        render 'users/registrations/new'
      end
    end

    def after_sign_in_path_for(resource)
      if request.referer == new_user_session_url
        super
      else
        request.env['omniauth.origin'] || stored_location_for(resource) || root_path
      end
    end
  end
end
