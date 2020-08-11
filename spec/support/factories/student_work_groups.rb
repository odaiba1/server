FactoryBot.define do
  factory :student_work_group do
    turn   { true }
    joined { true }
    association :user
    association :work_group
  end
end
