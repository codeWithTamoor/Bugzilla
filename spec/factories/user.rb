FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    type { "User" }

    factory :manager, class: 'Manager' do
      type { "Manager" }
    end

    factory :developer, class: 'Developer' do
      type { "Developer" }
    end

    factory :qa, class: 'Qa' do
      type { "Qa" }
    end
  end
end
