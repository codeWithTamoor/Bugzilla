# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    name { "Project #{Faker::Lorem.unique.word}" }
    desc { Faker::Lorem.sentence }
    association :manager, factory: :manager
  end
end
