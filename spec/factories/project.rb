FactoryBot.define do
  factory :project do
    title { Faker::Name.name }
  end
end
