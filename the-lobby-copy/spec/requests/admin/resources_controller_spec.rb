require 'rails_helper'

RSpec.describe Admin::ResourcesController, type: :request do
  before(:each) do
    @user = create(:user)
    @agency = create(:agency)
    @resource = create(:resource)
    @user.add_as_admin_of(@agency)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
    sign_in @user
  end

  describe "agency admin cannot make resources as highlight" do
    it "should not allow agency admin to create a global resource" do
      post "/admin/resources", :params => { :resource => {title: "Test1", url: "www.test.com", agency_ids: [], image:  Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png'), tag_names: "Enter Tags", global: true}, :as_values_resource_tags => ""}
      expect(flash[:error]).to eq "You are not authorized to perform this action."
      expect(response).to redirect_to admin_root_path
    end

    it "should not allow agency admin to create a highlight resource" do
      post "/admin/resources", :params => { :resource => {title: "Test1", url: "www.test.com", agency_ids: [], image:  Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png'), tag_names: "Enter Tags", global: true, highlight: true}, :as_values_resource_tags => ""}
      expect(flash[:error]).to eq "You are not authorized to perform this action."
      expect(response).to redirect_to admin_root_path
    end
  end

  describe "should save tag if present otherwise no tags saved" do
    it "empty tag field" do
      post "/admin/resources", :params => { :resource => {title: "Test_Resource", url: "www.testexample.com", agency_ids: [@agency.id], image:  Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png'), tag_names: "Enter Tags"}, :as_values_resource_tags =>""}
      expect(flash[:notice]).to eq "Resource created"
      expect(Resource.last.tags.empty?).to be true
    end

    it "resource with one tag" do
      post "/admin/resources", :params => { :resource => {title: "Test_Resource", url: "www.testexample.com", agency_ids: [@agency.id], image:  Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png'), tag_names: "Tag1"}, :as_values_resource_tags =>""}
      expect(flash[:notice]).to eq "Resource created"
      expect(Resource.last.tags.empty?).to be false
      expect(Resource.last.tags.length).to eq(1)
      expect(Resource.last.tags.first.name).to eq("Tag1")
    end
  end

  describe "only global admin can access all resources " do 
    before(:each) do
      @user.roles.create(name: "global_admin")
      @resource.global = true
      @resource.save
    end

    it "should allow global admin to access global resource show page" do 
      get admin_resource_path(@resource)
      expect(response).to have_http_status(200)
    end
    it "should allow global admin to delete global resource" do
      delete admin_resource_path(@resource)
      expect(flash[:notice]).to eq "Resource was successfully destroyed."
    end
    it "should allow global admin to edit global resourcee" do
      get edit_admin_resource_path(@resource)
      expect(response).to have_http_status(200)
    end

  end


  describe "set global resource as agency resource" do
    before(:each) do
      @user.roles.create(name: "global_admin")
      @agency = create(:agency)
      @resource.global = true
      @resource.agency_ids = [@agency.id]
      @resource.save
    end

    it "show global resource in agency resource" do
        get admin_resource_path(@resource)
        expect(response).to have_http_status(200)
    end

    it "agency admin can update global agency resources" do
        post "/admin/resources", :params => { :resource => {title: "Test_Resource", url: "www.testexample.com", agency_ids: [@agency.id], image:  Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png'), tag_names: "Enter Tags"}, :as_values_resource_tags =>""}
        expect(flash[:notice]).to eq "Resource created"
        expect(Resource.last.tags.empty?).to be true
    end

    it "agency admin can edit global agency resources" do
      get edit_admin_resource_path(@resource)
      expect(response).to have_http_status(200)
    end


  end

  describe "Agency admin can not access global resources" do
    it "should not allow agency admin to delete global resource" do
      @user.add_as_admin_of(@agency)
      delete admin_resource_path(@resource)
      expect(flash[:error]).to eq "You are not authorized to perform this action."
      expect(response).to redirect_to admin_root_path
    end

    it "should not allow agency admin to edit global resource" do
      @user.add_as_admin_of(@agency)
      get edit_admin_resource_path(@resource)
      expect(flash[:error]).to eq "You are not authorized to perform this action."
      expect(response).to redirect_to admin_root_path
    end
  end
end