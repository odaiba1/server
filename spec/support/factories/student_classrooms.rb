FactoryBot.define do
  factory :student_classroom do
    user      { create(:student) }
    classroom { create(:classroom) }
  end
end
