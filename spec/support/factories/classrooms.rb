FactoryBot.define do
  factory :classroom do
    name { 'Test Classroom' }
    user { create(:teacher) }
  end
end
