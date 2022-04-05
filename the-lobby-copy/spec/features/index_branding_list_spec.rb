require "rails_helper"

RSpec.feature "Branding Index list and Create Method Check", :type => :feature do
  before :each do
    @user = create(:user)
    @agency = create(:agency)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
  end

  describe "user can view branding section" do
    before :each do
      @global_branding = create(:branding, name: "default")
      @agency_branding = create(:branding, agency_ids: [@agency.id])
    end

    it "global admin can view all brandings" do 
      @user.roles.create(name: "global_admin") 
      visit "/admin/brandings"
      expect(page.status_code).to eq(200)
      expect(page).to have_selector "#branding_#{@global_branding.id}"
      expect(page).to have_selector "#branding_#{@agency_branding.id}"
    end

    it "agency admin can only view its agency related brandings" do
      @user.add_as_admin_of(@agency)
      visit "/admin/brandings"
      expect(page.status_code).to eq(200)
      expect(page).not_to have_selector "#branding_#{@global_branding.id}"
      expect(page).to have_selector "#branding_#{@agency_branding.id}"

    end
  end

  describe "Create New Branding" do
    it "should display in branding index page" do
      @user.add_as_admin_of(@agency)
      visit "/admin/brandings/new"
      fill_in 'Name', with: 'Test_Brand'
      attach_file('Logo', Rails.root + 'spec/support/assets/images/1px.png')
      select @agency.name, from: 'Agencies'
      click_on 'Create Branding'
      expect(page.status_code).to eq(200)
      visit "/admin/brandings"
      expect(page.find("#branding_#{Branding.last.id}"))
    end

    it "should save the agency_id selected in the dropdown", type: :request do
      @user.add_as_admin_of(@agency)
      res = post "/admin/brandings", :params => { :branding => {name: "Test1", logo: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png'), agency_ids: ["#{@agency.id}"]}}
      expect(Branding.last.name).to eq("Test1")
      expect(Branding.last.agencies.pluck(:id)).to eq([@agency.id])
    end
  end
end
