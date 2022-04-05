require "rails_helper"

RSpec.feature "Default Landing page after login", :type => :feature do
  before :all do
    @agency = create(:agency, name: "TEST", city: "Test City", country: "Test Country", region: "Test Region", physical_delivery_office_name: 77)
    OmniAuth.config.test_mode = true
  end
  
  describe "redirect to resources index page after login" do
    it "user is a global admin" do 
      OmniAuth.config.mock_auth[:openam] = OmniAuth::AuthHash.new({
        :provider => 'openam',
        :mail => 'example@test.com',
        :sn => 'sname',
        :givenName => 'test',
        :extra =>  {:raw_info => {client_id: "the-lobby", company: "77", dn: "CN=example@test.com,OU=TEST,OU=Test City,OU=Test Country,OU=Test Region,OU=TBWA,DC=global,DC=organis", expires_in: 38, givenName: "Test", grant_type: "authorization_code", mail: "test@example.com", :tbwaUid => '07', :memberOf => 'CN=dteam@mytbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org,CN=IN-Noida-Everyone,OU=Noida,OU=IN, OU=AP,OU=Groups,DC=globalad,DC=org,CN=O365enabled,OU=O365,OU=Groups,DC=globalad,DC=org,CN=Everyone-o-tbwa-AUTOPOP,OU=Library, OU=Applications,OU=Groups,DC=globalad,DC=org,CN=WTG-Developers,OU=WTG,OU=Groups,DC=globalad,DC=org,CN=Openshift,OU=Okta,OU=Channels, OU=Applications,OU=Groups,DC=globalad,DC=org,CN=devteam@tbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org, CN=Admin,OU=mytbwa2,OU=Applications,OU=Groups,DC=globalad,DC=org'}}
      })
      visit '/'
      find('#page_title').has_content?("Resources")
    end

    it "user is an agency admin" do
      user = create(:user, :email => 'example@test.com', :tbwa_uid => 07)
      user.roles.create(name: "agency_admin", agency_id: @agency.id)
      OmniAuth.config.mock_auth[:openam] = OmniAuth::AuthHash.new({
        :provider => 'openam',
        :mail => 'example@test.com',
        :sn => 'sname',
        :givenName => 'test',
        :extra =>  {:raw_info => {client_id: "the-lobby", company: "77", dn: "CN=example@test.com,OU=TEST,OU=Test City,OU=Test Country,OU=Test Region,OU=TBWA,DC=global,DC=organis", expires_in: 38, givenName: "Test", grant_type: "authorization_code", mail: "test@example.com", :tbwaUid => '7', :memberOf => 'CN=dteam@mytbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org,CN=IN-Noida-Everyone,OU=Noida,OU=IN, OU=AP,OU=Groups,DC=globalad,DC=org,CN=O365enabled,OU=O365,OU=Groups,DC=globalad,DC=org,CN=Everyone-o-tbwa-AUTOPOP,OU=Library, OU=Applications,OU=Groups,DC=globalad,DC=org,CN=WTG-Developers,OU=WTG,OU=Groups,DC=globalad,DC=org,CN=Openshift,OU=Okta,OU=Channels, OU=Applications,OU=Groups,DC=globalad,DC=org,CN=devteam@tbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org'}}
      })
      visit '/'
      find('#page_title').has_content?("Resources")
    end
  end
end
