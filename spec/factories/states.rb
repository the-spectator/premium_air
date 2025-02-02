FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
  end
end
