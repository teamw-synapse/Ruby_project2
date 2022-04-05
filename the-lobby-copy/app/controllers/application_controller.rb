# frozen_string_literal: true

class ApplicationController < ActionController::Base
  alias_method :current_admin_user, :current_user

  helper_method :destroy_admin_user_session_path, :current_admin_user

  before_action :set_symlink # DIRTIEST HACK - Found no way to set a symlink on the deployed container in OpenShift

  def authenticate_admin_user!
    if current_admin_user.blank?
      reset_session
      redirect_to new_session_path
    end
  end

  def new_session_path
    user_openam_omniauth_authorize_path
  end

# this method is not used for a redirect or logout functionality. Only the path is returned to be populated in the view and the element is hidden
  def destroy_admin_user_session_path
    "/admin/logout"
  end


  private

  def set_symlink
    system("ln -s /data ./public/data") unless Dir.exists?("public/data")
  end

end
