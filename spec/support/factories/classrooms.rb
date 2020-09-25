FactoryBot.define do
  factory :classroom do
    name { 'Test Classroom' }
    start_time {Time.new(2021, 10, 18, 9, 0, 0)}
    end_time {Time.new(2021, 10, 18, 10, 15, 0)}
    user { create(:teacher) }
  end
end
