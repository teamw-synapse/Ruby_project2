FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    email {Faker::Internet.unique.email}
    tbwa_uid {SecureRandom.hex(4)}
  end
end
