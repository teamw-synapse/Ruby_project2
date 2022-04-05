require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe "initialize resource position after resource is created" do
    it "should assign position after a resource is created" do
      resource = create(:resource)
      expect(resource.position).to eq(resource.id)
    end
  end
  
  describe "Template cannot be set global" do
    it "should throw error if resource template is set as global" do
      resource = create(:resource, template: true)
      resource.global = true
      expect(resource.save).to eq(false)
    end
  end
  
  describe "agency resource cannot be set template" do
    it "should throw error if agency resource is set in template resource" do
      agency = create(:agency)
      resource = create(:resource, agencies: [agency])
      resource.template = true
      expect(resource.save).to eq(false)
    end
  end
  
  describe "User name and password cannot be set template" do
    it "should throw error if username or password is set in template resource" do
      resource = create(:resource, username: "anshul")
      resource.template = true
      expect(resource.save).to eq(false)
    end
  end

  describe "#update_highlight_position" do
    context 'it should update the highlight position before saving the resource' do
      it 'should set the highlight position to the last in highlights when the highlight is marked true - for new resource' do
        resource = build(:resource, global: true, highlight: true)
        new_highlight_position = Resource.maximum(:highlight_position).to_i + 1
        resource.send(:update_highlight_position)
        expect(resource.highlight_position).to eq(new_highlight_position)
      end

      it 'should set the highlight position to nil when the highlight is marked false - when updating a resource' do
        resource = create(:resource, global: true, highlight: true)
        resource.highlight = false
        resource.send(:update_highlight_position)
        expect(resource.highlight_position).to eq(nil)
      end
    end
  end

  describe "highlight_only_if_global_selected" do
    context 'it should validate and throw an error if user is setting highlight to true with setting global to true' do
      it 'will throw error if global is false and user trying to set highlight to true' do
        resource = create(:resource, global: false)
        resource.highlight = true
        expect(resource.save).to eq(false)
      end

      it 'will not throw error if both global and highlight are set to true' do
        resource = build(:resource)
        resource.global = true
        resource.highlight = true
        expect(resource.save).to eq(true)
      end
    end
  end

  it "should validate url format and append http if absent" do
    resource = build(:resource)
    resource.url = "aa"
    expect(resource).not_to be_valid
    expect(resource.url.start_with?("http://")).to eq(true)
    expect(resource.errors[:url].size).to eq(1)
  end

  # describe "Resource will get template image" do
  #   it "should create resource with template image if resource image not present" do
  #     resource_template = create(:resource, template: true)
  #     stub_request(:get, resource_template.image.url).
  #        with(
  #          headers: {
  #      	  'Accept'=>'*/*',
  #      	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #      	  'User-Agent'=>'CarrierWave/1.3.1'
  #          }).
  #        to_return(status: 200, body: "", headers: {})
  #     resource = create(:resource, global: true)
  #     resource.image = nil
  #     resource.remote_image_url = resource_template.image.url
  #     expect(resource.save).to eq(true)
  #     expect(resource.image.url).to eq(resource_template.image.url)      
  #   end
  # end
end
