FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    name { "Test User" }

    factory :manager, class: 'Manager' do
      type { 'Manager' }
    end

    factory :developer, class: 'Developer' do
      type { 'Developer' }
    end

    factory :qa, class: 'Qa' do
      type { 'Qa' }
    end
  end
end
