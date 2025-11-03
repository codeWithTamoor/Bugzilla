# spec/factories/tickets.rb
FactoryBot.define do
  factory :ticket do
    sequence(:title) { |n| "Ticket #{n}" }
    description { "Sample ticket" }
    status { :new_ticket }
    association :qa, factory: :qa
    association :project
    type { "Ticket" }

    factory :bug, class: 'Bug'
    factory :feature, class: 'Feature'
  end
end
