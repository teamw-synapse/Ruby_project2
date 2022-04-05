require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  context "For a user created with an role" do
    it "should return agency the user belongs to" do
      agency = create(:agency)
      user = create(:user)
      role = build(:role)
      role.agency_id = agency.id
      role.user_id = user.id
      role.save
      expect(user.agency).to eq(agency)
    end
  end
end
