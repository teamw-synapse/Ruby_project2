require "rails_helper"


RSpec.describe Admin::HighlightsController, type: :request do

  before(:each) do
		@agency = create(:agency)
		@user = create(:user)
		allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(nil)
		allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(@user)
		sign_in @user
	end

  it "should not allow agency admin to access highlight page" do
		

		@user.add_as_admin_of(@agency)
		get admin_highlights_path
		expect(flash[:error]).to eq "You are not authorized to perform this action."
		expect(response).to redirect_to admin_root_path
	end
	
	it "should display highlights" do
		@user.roles.create(name: "global_admin")
		get admin_highlights_path
		expect(response).to have_http_status(200)
  end

end