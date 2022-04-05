require "rails_helper"

RSpec.feature "Create Resource and Resource Index Page", :type => :feature do
  before :each do
    @user = create(:user)
    @agency_1 = create(:agency)
    @agency_2 = create(:agency, name: "TBWA worldwide")
    @agency_3 = create(:agency, name: "TBWA London")
    @user.add_as_admin_of(@agency_1)
    @user.add_as_admin_of(@agency_2)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
  end

  describe "user is a agency_admin not global_admin" do
    it "Shows only agencies in new resource form dropdown whose local admin is current user" do
      visit "/admin/resources/new"
      agency_ids = find_field('Agencies').all('option').collect(&:value).reject(&:blank?).map(&:to_i)
      expect(agency_ids).to eq([@agency_1.id, @agency_2.id])
    end

    it "should not show those agencies in new resource form dropdown whose agency admin is not current user" do
      visit "/admin/resources/new"
      agency_ids = find_field('Agencies').all('option').collect(&:value).reject(&:blank?).map(&:to_i)
      expect(agency_ids).not_to include(@agency_3.id)
    end
  end

  describe "user is a global_admin" do
    it "Shows all the agencies to user who is global admin" do
      @user.roles.create(name: "global_admin")
      visit "/admin/resources/new"
      agency_ids = find_field('Agencies').all('option').collect(&:value).reject(&:blank?).map(&:to_i)
      expect(agency_ids.sort).to eq(Agency.all.pluck(:id).sort)
    end
  end

  describe "resources on index page" do
    before :each do
      @agency_resource = create(:resource, title: "agency_resource", agencies: [@agency_1])
      @global_resource = create(:resource, title: "global_resource", global: true)
    end

    it "global admin can see all the resources" do
      @user.roles.create(name: "global_admin")
      visit "/admin/resources"
      expect(page.status_code).to eq(200)
      expect(page).to have_selector "#resource_#{@global_resource.id}"
      expect(page).to have_selector "#resource_#{@agency_resource.id}"
    end

    it "agency admin can see global resources and their agency resources" do
      @user.add_as_admin_of(@agency_1)
      visit "/admin/resources"
      expect(page.status_code).to eq(200)
      expect(page).to have_selector "#resource_#{@global_resource.id}"
      expect(page).to have_selector "#resource_#{@agency_resource.id}"
    end
  end
end
