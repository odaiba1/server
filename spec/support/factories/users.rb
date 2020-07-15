FactoryBot.define do
  factory :teacher, class: User do
    name     { 'Paulo' }
    email    { 'paulo@teacher.com' }
    password { 'password' }
    role     { 1 }
  end
end
