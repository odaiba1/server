FactoryBot.define do
  factory :worksheet_review do
    content     { 'Test' }
    user        { create(:student) }
    worksheet   { create(:worksheet) }
  end
end
