require "rails_helper"

RSpec.feature "Branding form agency list", :type => :feature do
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

  describe "user is a agency_admin" do
    it "Shows only agencies in dropdown whose local admin is current user" do
      visit "/admin/brandings/new"
      agency_ids = find_field('Agencies').all('option').collect(&:value).reject(&:blank?).map(&:to_i)
      expect(agency_ids.sort).to eq([@agency_1.id, @agency_2.id].sort)
    end

    it "should not show those agencies in dropdown whose agency admin is not current user" do
      visit "/admin/brandings/new"
      agency_ids = find_field('Agencies').all('option').collect(&:value).reject(&:blank?).map(&:to_i)
      expect(agency_ids).not_to include(@agency_3.id)
    end
  end

  describe "user is a global_admin" do
    it "Shows all the agencies to user who is global admin" do
      @user.roles.create(name: "global_admin")
      visit "/admin/brandings/new"
      agency_ids = find_field('Agencies').all('option').collect(&:value).reject(&:blank?).map(&:to_i)
      expect(agency_ids.sort).to eq(Agency.all.pluck(:id).sort)
    end
  end

  describe "default branding have disabled default checkbox" do
    before :each do
      @branding = create(:branding, default: true)
    end
    
    it "when user is agency admin" do
      visit "/admin/brandings/#{@branding.id}/edit"         
        expect(page).not_to have_selector('#branding_default')
    end

    it "when user is global admin" do
      @user.roles.create(name: "global_admin")
      visit "/admin/brandings/#{@branding.id}/edit"
      expect(page).to have_selector('#branding_default')
    end
  end
end
