FactoryBot.define do
  factory :worksheet do
    title { 'Test' }
    association :worksheet_template
    association :work_group
  end
end
