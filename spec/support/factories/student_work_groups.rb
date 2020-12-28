FactoryBot.define do
  factory :student_work_group do
    turn       { false }
    joined     { true }
    user       { create(:student) }
    work_group { create(:work_group) }
  end
end
