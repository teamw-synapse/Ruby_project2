require "rails_helper"

RSpec.feature "Agency Option in Active Admin Menu bar", :type => :feature do
  before  :each do
    @user = create(:user)
    @agency = create(:agency)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
  end

  describe "Current User is a global admin" do
    it "should display Agencies and Users tabs in menu bar" do
      @user.roles.create(name: "global_admin")
      visit "/"
      expect(page.all(:css,'#agencies')).not_to be_empty
      expect(page.all(:css,'#users')).not_to be_empty
    end
  end

  describe "Current User is both global and agency admin" do
    it "should display Agencies and Users tabs in menu bar" do
      @user.roles.create(name: "global_admin")
      @user.add_as_admin_of(@agency)
      visit "/"
      expect(page.all(:css,'#agencies')).not_to be_empty
      expect(page.all(:css,'#users')).not_to be_empty
    end
  end

  describe "Current User is a agency admin" do
    it "should not display Agencies and Users tabs in menu bar" do
      @user.add_as_admin_of(@agency)
      visit "/" 
      expect(page.all(:css,'#agencies')).to be_empty
      expect(page.all(:css,'#users')).to be_empty
    end
  end
end
