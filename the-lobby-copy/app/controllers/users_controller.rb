# frozen_string_literal: true

class UsersController < ApplicationController

  def user_info
    access_token = request.headers['OAuthToken']
    render json: {}, status: 401 and return if access_token.blank?
    user_info = HTTParty.get('https://auth.factory.tools/openam/oauth2/tokeninfo', query: { access_token: access_token })
    render json: {}, status: 401 and return if user_info.code == 401
    agency = UserService.find_user_agency user_info
    branding = agency.branding.blank? ? Branding.default : agency.branding
    user = UserService.create_or_update_user user_info, agency
    agency_admin = User.includes(:roles).where(roles: {name: "agency_admin", agency_id: agency.id}).pluck(:email)
    ## Default agency admin to show in angular frontend popover.
    agency_admin = Settings.default_agency_admin_email if agency_admin.empty?

    agency_json = ActiveModelSerializers::SerializableResource.new(agency).as_json
    branding_json = ActiveModelSerializers::SerializableResource.new(branding).as_json
    agency_resources = (agency.resources.joins(:resource_clicks).where(resource_clicks: {user_id: user.id}).order("resource_clicks.count DESC") + agency.resources).uniq
    agency_resources_json = ActiveModelSerializers::SerializableResource.new(agency_resources).as_json
    global_resources = (Resource.set_global_resource_as_agency_resource_for_selected_agencies(agency.id).joins(:resource_clicks).where(resource_clicks: {user_id: user.id}).order("resource_clicks.count DESC") + Resource.set_global_resource_as_agency_resource_for_selected_agencies(agency.id)).uniq
    global_resources_json = ActiveModelSerializers::SerializableResource.new(global_resources).as_json

    respond_to do |format|
      format.json do
        render json: {
          name: user_info["givenName"],
          user_id: user.id,
          is_admin: user.admin?,
          agency: agency_json,
          agency_admin: agency_admin,
          branding: branding_json,
          agency_resources: agency_resources_json,
          global_resources: global_resources_json
        }
      end
    end
  end

end
