# spec/factories/tickets.rb
FactoryBot.define do
  factory :ticket do
    title       { "Ticket #{Faker::Number.unique.number(digits: 3)}" }
    status      { 0 } # assuming enum 0 = new_ticket
    description { Faker::Lorem.sentence }
    deadline    { Date.today + 7.days }
    association :developer, factory: :developer
    association :qa, factory: :qa
    association :project

    factory :bug, class: 'Bug'
    factory :feature, class: 'Feature'
  end
end
