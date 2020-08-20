FactoryBot.define do
  factory :worksheet_template do
    title     { 'Test' }
    image_url { 'xxx' }
    association :user, factory: :teacher
  end
end
