FactoryBot.define do
  factory :worksheet do
    title { 'Test' }
    canvas { 'abc' }
    association :worksheet_template
    association :work_group
  end
end
