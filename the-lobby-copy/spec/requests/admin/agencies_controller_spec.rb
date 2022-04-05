
require 'rails_helper'

RSpec.describe Admin::AgenciesController, type: :request do

  before(:each) do
		@agency = create(:agency)
		@user = create(:user)
		allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
		allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
		sign_in @user
	end

  describe "add/remove agency_admin" do
    before :each do
      @user.roles.create(name: "global_admin")
    end

    it "should flash alert if no email is selected in remove as agency admin" do
      post add_agency_admin_admin_agency_path(@agency), params: {id: @agency.id}
      expect(flash[:alert]).to eq "Please select a user to create agency admin"
      expect(response).to redirect_to admin_agency_path(@agency)
    end

	  it "should flash alert if no email is selected in remove as agency admin" do
      post remove_agency_admin_admin_agency_path(@agency), params: {id: @agency.id}
      expect(flash[:alert]).to eq "Please select a user to Remove as agency admin"
      expect(response).to redirect_to admin_agency_path(@agency)
	  end

	  it "should allow only global admin to set local admin" do
      new_user_to_add = create(:user)
      post add_agency_admin_admin_agency_path(@agency), params: {id: @agency.id, ad_email: new_user_to_add.email}
      expect(flash[:notice]).to eq "#{new_user_to_add.email} added as Agency admin"
      expect(response).to redirect_to admin_agency_path(@agency)
	  end

    it "should allow only global admin to remove local admin" do
      user_to_remove_as_admin = create(:user)
      user_to_remove_as_admin.add_as_admin_of(@agency)
      post remove_agency_admin_admin_agency_path(@agency), params: {id: @agency.id, user_id: user_to_remove_as_admin.id}
      expect(flash[:notice]).to eq "#{user_to_remove_as_admin.email} removed as Agency admin"
      expect(response).to redirect_to admin_agency_path(@agency)
    end

    it "should create user if the user to made agency admin is not present" do
      new_user_to_add_email = "abc@tbwa.com"
      post add_agency_admin_admin_agency_path(@agency), params: {id: @agency.id, ad_email: new_user_to_add_email}
      expect(flash[:notice]).to eq "#{new_user_to_add_email} added as Agency admin"
      expect(response).to redirect_to admin_agency_path(@agency)
      expect(User.last.email).to eq(new_user_to_add_email)
      expect(User.last.added_as_agency_admin).to eq(true)
    end

    it "should show error if user is already an agency admin" do
      new_user_to_add = create(:user)
      new_user_to_add.add_as_admin_of(@agency)
      post add_agency_admin_admin_agency_path(@agency), params: {id: @agency.id, ad_email: new_user_to_add.email}
      expect(flash[:notice]).to eq "#{new_user_to_add.email} is already an Agency admin"
      expect(response).to redirect_to admin_agency_path(@agency)
    end
  end

  describe "only global admin can visit agency index/show page" do
    it "should not allow agency admin to access agency index page" do
      @user.add_as_admin_of(@agency)
      get admin_agencies_path
      expect(flash[:error]).to eq "You are not authorized to perform this action."
      expect(response).to redirect_to admin_root_path
    end

    it "should allow global admin to access agency index page" do
      @user.roles.create(name: "global_admin")
      get admin_agencies_path
	  	expect(response).to have_http_status(200)
    end

    it "should not allow agency admin to access agency show page" do
      @user.add_as_admin_of(@agency)
      get admin_agency_path(@agency)
      expect(flash[:error]).to eq "You are not authorized to perform this action."
      expect(response).to redirect_to admin_root_path
    end
                                                                                   
    it "should allow global admin to access agency show page" do
      @user.roles.create(name: "global_admin")
      get admin_agency_path(@agency)
    	expect(response).to have_http_status(200)
    end
  end
end
