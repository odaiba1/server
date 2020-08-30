FactoryBot.define do
  factory :worksheet_template do
    title     { 'Test' }
    image_url { 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg' }
    user      { create(:teacher) }
  end
end
