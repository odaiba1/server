FactoryBot.define do
  factory :teacher, class: User do
    name     { 'Paulo' }
    password { 'password' }
    role     { 1 }
    sequence(:email) { |n| "paulo#{n}@teacher.com" }
  end

  factory :student, class: User do
    name     { 'Taro' }
    password { 'password' }
    role     { 0 }
    sequence(:email) { |n| "taro#{n}@student.com" }
  end

  factory :admin, class: User do
    name     { 'Dzakki' }
    password { 'password' }
    role     { 2 }
    sequence(:email) { |n| "dzakki#{n}@admin.com" }
  end
end
