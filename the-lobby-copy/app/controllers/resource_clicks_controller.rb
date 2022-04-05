class ResourceClicksController < ApplicationController
  protect_from_forgery prepend: true

  def create
    data = JSON.parse params["click_data"]
    user_id = data["user_id"]

    res_click = ResourceClick.find_or_initialize_by(resource_id: data["resource_id"], user_id: data["user_id"])

    res_click.count +=1
    res_click.save!
  end
end
