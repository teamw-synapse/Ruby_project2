require "rails_helper"

RSpec.feature "Add Agency Admin and Verify the added user attributes on login", :type => :feature do
  describe "Add a user via email as agency admin from agency show page" do
    before :all do
      @user = create(:user)
      @user_email_to_add_as_agency_admin = "abc@example.com"
      @agency = create(:agency)
      @user.roles.create(name: "global_admin")
    end
    
    it "Add a user via email as agency admin" do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
      allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
      visit "/admin/agencies/#{@agency.id}"
      expect(User.find_by_email(@user_email_to_add_as_agency_admin)).to eq(nil)
      fill_in 'ad_email', with: @user_email_to_add_as_agency_admin 
      click_on 'Add Agency Admin'
      expect(find('.flash').text).to eq("#{@user_email_to_add_as_agency_admin}"+" added as Agency admin")
      expect(User.last.email).to eq(@user_email_to_add_as_agency_admin)
      expect(User.last.added_as_agency_admin).to eq(true)
    end
  end
end
