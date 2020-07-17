FactoryBot.define do
  factory :teacher, class: User do
    name     { 'Paulo' }
    password { 'password' }
    role     { 1 }
    sequence(:email) { |n| "paulo#{n}@teacher.com" }
  end

  factory :student, class: User do
    role { 2 }
  end
end
