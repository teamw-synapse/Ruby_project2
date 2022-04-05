FactoryBot.define do
  factory :branding do
    name { "New Branding" }
    primary_color { "#fff" }
    secondary_color { "#fff" }
    logo { Rack::Test::UploadedFile.new( Rails.root.join('spec/support/assets/images/1px.png'), 'image/png') }
  end
end
