FactoryBot.define do
  factory :task do
    title { Faker::Name.name }
    description { Faker::Name.name }
    status { rand(1) }
    project
  end
end
