
require 'rails_helper'

RSpec.describe UsersController, type: :request do

  it "should return unauthorized if no access token is passed" do
    get user_info_users_path
    expect(response).to have_http_status(401)
  end

  it "should return unauthorized if wrong access token is passed" do
    stub_request(:get, "https://auth.factory.tools/openam/oauth2/tokeninfo?access_token=WRONG").
      with(headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent'=>'Ruby'
      }).to_return(status: 401, body: "", headers: {})
    get user_info_users_path, headers: {'OAuthToken' => "WRONG"}
    expect(response).to have_http_status(401)
  end

  it "should return agency, resources and branding for a user successfully" do

    user = create(:user)
    agency = create(:agency)
    branding = create(:branding, default: true)
    user.roles.create(name: "user", agency_id: agency.id)

    res_body_hsh = {"mail"=>user.email, "givenName"=>"Alok", "dn"=>"CN=alok.swain@magnontbwa.com,OU=#{agency.name},OU=Noida,OU=IN,OU=Asia Pacific,OU=TBWA,DC=globalad,DC=org",
    "token_type"=>"Bearer", "client_id"=>"the-lobby", "access_token"=>"9f3de0b1-e297-45cb-8716-5df0148a875d", "tbwaUid"=>"105414", "grant_type"=>"token",
    "scope"=>["tbwaUid", "mail", "givenName", "company", "dn", "memberOf", "sn"], "realm"=>"/test", "company"=>"123",
    "memberOf"=>"CN=dteam@mytbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org,CN=IN-Noida-Everyone,OU=Noida,OU=IN,OU=AP,OU=Groups,DC=globalad,DC=org,CN=O365enabled,OU=O365,OU=Groups,DC=globalad,DC=org,CN=Admin,OU=mytbwa2,OU=Applications,OU=Groups,DC=globalad,DC=org,CN=Everyone-o-tbwa-AUTOPOP,OU=Library,OU=Applications,OU=Groups,DC=globalad,DC=org,CN=WTG-Developers,OU=WTG,OU=Groups,DC=globalad,DC=org,CN=Openshift,OU=Okta,OU=Channels,OU=Applications,OU=Groups,DC=globalad,DC=org,CN=devteam@tbwa.com,OU=O365,OU=Groups,DC=globalad,DC=org",
    "sn"=>"Swain", "expires_in"=>3579}

    stub_request(:get, "https://auth.factory.tools/openam/oauth2/tokeninfo?access_token=CORRECT").
      with(headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent'=>'Ruby'
      }).to_return(status: 200, body: res_body_hsh.to_json, headers: {"Content-type" => "application/json"})

    get user_info_users_path, headers: {'OAuthToken' => "CORRECT"}
    expect(response).to have_http_status(200)
  end

end
