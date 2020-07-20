FactoryBot.define do
  factory :student_classroom do
    association :user
    association :classroom
  end
end
