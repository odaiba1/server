FactoryBot.define do
  factory :worksheet do
    title     { 'Test' }
    canvas    { 'abc' }
    image_url { 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg' }
    association :worksheet_template
    association :work_group
  end
end
