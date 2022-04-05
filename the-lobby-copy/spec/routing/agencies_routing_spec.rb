require "rails_helper"

RSpec.describe "routes for agencies" do

	before(:each) do
		@agency = create(:agency)
	end

	describe "Should not Create/Update/delete Agency" do

		it "should not get the new page of agency" do
			expect(:get => "/admin/agencies/new").not_to route_to("admin/agencies#new")
		end

		it "should not be able to delete existing agency" do
			expect(:delete => "/admin/agencies/#{@agency.id}").not_to be_routable
		end

		it "should not have route for create/update agency" do
			expect(:post => "/admin/agencies/#{@agency.id}").not_to be_routable
			expect(:put => "/admin/agencies/#{@agency.id}").not_to be_routable
			expect(:patch => "/admin/agencies/#{@agency.id}").not_to be_routable
		end
	end
end