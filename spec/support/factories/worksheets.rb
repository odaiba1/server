FactoryBot.define do
  factory :worksheet do
    title     { 'Test' }
    canvas    { 'abc' }
    image_url { 'xxx' }
    association :worksheet_template
    association :work_group
  end
end
