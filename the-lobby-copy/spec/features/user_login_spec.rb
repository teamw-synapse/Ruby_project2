require "rails_helper"

RSpec.feature "Login user added as agency admin and verify its attributes after sign in", :type => :feature do
  it "user added as agency admin and then created user sign_in and verify user details" do
    @user = create(:user)
    @agency = create(:agency)
    @user.roles.create(name: "global_admin")
    user = User.create(email: "abc@magnon.com", added_as_agency_admin: true)
    user.add_as_admin_of(@agency)
    first_name = "ABC"
    last_name = "BCA"
    tbwa_uid  = "7575"

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:openam] = OmniAuth::AuthHash.new({
      :extra => {:raw_info => {:access_token => "8499c494-b618-45ae-8cab-68062f0ac06b", :client_id=>"the-lobby", :company=>@agency.physical_delivery_office_name, :dn=>"CN=abc@magnon.com,OU=Magnon,OU=Noida,OU=IN,OU=Asia Pacific,OU=TBWA,DC=globalad,DC=org", :givenName=>first_name, :grant_type=>"authorization_code", :mail=>user.email, :memberOf=>"CN=dteam@mytbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org,CN=IN-Noida-Everyone,OU=Noida,OU=IN,OU=AP,OU=Groups,DC=globalad,DC=org,CN=O365enabled,OU=O365,OU=Groups,DC=globalad,DC=org,CN=Everyone-o-tbwa-AUTOPOP,OU=Library,OU=Applications,OU=Groups,DC=globalad,DC=org,CN=WTG-Developers,OU=WTG,OU=Groups,DC=globalad,DC=org,CN=Openshift,OU=Okta,OU=Channels,OU=Applications,OU=Groups,DC=globalad,DC=org,CN=devteam@tbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org",
      :sn =>last_name,
      :tbwaUid => tbwa_uid}},
      :provider=>"openam",
      :uid=>nil
    })

    visit '/admin'
    updated_user = User.find(user.id)
    expect(page.status_code).to eq(200)
    expect(page.current_url).to eq("http://www.example.com/admin")
    expect(updated_user.email).to eq(user.email)
    expect(updated_user.tbwa_uid).to eq(tbwa_uid)
    expect(updated_user.first_name).to eq(first_name)
    expect(updated_user.last_name).to eq(last_name)
  end
end
