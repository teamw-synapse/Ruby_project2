# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def openam
    user_info = request.env['omniauth.auth']
    user_info = user_info.extra.raw_info
    @user = UserService.create_or_update_user user_info
    if @user && @user.persisted? && @user.admin?
      reset_session
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
    else
      request.env['omniauth.auth'] = nil
      reset_session
      render action: :failure
    end
  end

  def failure
  end
end
