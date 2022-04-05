FactoryBot.define do
  factory :resource do
    title { "Acme Inc. Resource" }
    url {"http://google.com"}
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/assets/images/1px.png'), 'image/png') }
  end
end
