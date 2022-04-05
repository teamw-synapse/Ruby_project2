require "rails_helper"

RSpec.feature "Tags Index Page", :type => :feature do
  before :each do
    @user = create(:user)
    @agency = create(:agency)
    @tag = Tag.create(name: "Tag1")
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
  end

  describe "any user can view tags section" do
    it "global admin can view all tags" do 
      @user.roles.create(name: "global_admin") 
      visit "/admin/tags"
      expect(page.status_code).to eq(200)
      expect(page).to have_selector "#tag_#{@tag.id}"
    end

    it "agency admin can view all tags" do
      @user.add_as_admin_of(@agency)
      visit "/admin/tags"
      expect(page.status_code).to eq(200)
      expect(page).to have_selector "#tag_#{@tag.id}"

    end
  end

  describe "Any user can view tag" do
    it "Admin can view all tags" do 
      @user.roles.create(name: "global_admin") 
      visit "/admin/tags/#{@tag.id}"
      expect(page.status_code).to eq(200)
      expect(page).to have_content("#{@tag.name}")
    end
  end
end
