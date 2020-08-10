FactoryBot.define do
  factory :worksheet_template do
    title { 'Test' }
    association :user, factory: :teacher
  end
end
