require 'rails_helper'

RSpec.describe Agency, type: :model do
  #describe "add branding to agency when branding template is passed" do
  #  it "should create branding for the agency when template branding id is passed" do
  #    branding = create(:branding)
  #    agency = create(:agency)
  #    agency.branding_template_id = branding.id
  #    agency.save
  #    agency.reload
  #    expect(agency.branding).to be_an_instance_of(Branding)
  #  end

  #  it "should remove branding for agency if branding template passed is blank" do
  #    agency = create(:agency)
  #    branding = create(:branding, agency_id: agency.id)
  #    agency.reload
  #    agency.branding_template_id = nil
  #    agency.save
  #    agency.reload
  #    expect(agency.branding).to eq(nil)
  #  end

  #  it "should update branding for agency if already present and branding template id is passed" do
  #    agency = create(:agency)
  #    branding = create(:branding, agency_id: agency.id)
  #    agency.reload
  #    agency.branding_template_id = Branding.last.id
  #    expect(agency.save).to eq(true)
  #    agency.reload
  #    expect(agency.branding).to be_an_instance_of(Branding)
  #  end
  #end
end
