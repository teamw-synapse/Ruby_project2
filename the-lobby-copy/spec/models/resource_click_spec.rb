require 'rails_helper'

RSpec.describe ResourceClick, type: :model do

  it "should validate resource_id, user_id, count" do
    rc = ResourceClick.new
    rc.valid?

    expect(rc.errors[:resource_id].length).to eq(1)
    expect(rc.errors[:user_id].length).to eq(1)
    expect(rc.errors[:count].length).to eq(1)
  end

  it "should throw error if count is not greater than 0" do
    rc = build(:resource_click)
    rc.count = -1
    rc.valid?
    expect(rc.errors[:count].length).to eq(1)
  end


end
