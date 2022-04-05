require "rails_helper"


RSpec.describe ResourceClicksController, type: :request do
  before :all do
    @resource = create(:resource)
    @user = create(:user)
  end

  it "should successfully create a resource click" do
    post resource_clicks_path, params: {click_data: {resource_id: @resource.id, user_id: @user.id}.to_json}
    new_rc_count = ResourceClick.where(resource_id: @resource.id, user_id: @user.id).count
    expect(new_rc_count).to eq(1)
  end

  it "should successfully update click count of a resource" do
    post resource_clicks_path, params: {click_data: {resource_id: @resource.id, user_id: @user.id}.to_json}
    post resource_clicks_path, params: {click_data: {resource_id: @resource.id, user_id: @user.id}.to_json}
    new_rc = ResourceClick.where(resource_id: @resource.id, user_id: @user.id).last
    expect(new_rc.count).to eq(2)
  end

end
