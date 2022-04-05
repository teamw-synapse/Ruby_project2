class Admin::SessionsController < ApplicationController

  before_action :authenticate_admin_user!, only: [:logout]

  def login
  end

  def logout
    session[:user_id] = nil
    request.env['omniauth.auth'] = nil
    redirect_to new_session_path
  end

end
