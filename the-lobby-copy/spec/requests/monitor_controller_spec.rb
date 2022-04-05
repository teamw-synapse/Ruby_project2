
require 'rails_helper'

RSpec.describe MonitorController, type: :request do

  it "should successfully hit the monitor controller index" do
    get "/monit"
    expect(response).to have_http_status(200)
  end

end
