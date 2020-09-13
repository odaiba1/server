FactoryBot.define do
  factory :classroom do
    subject { 'English' }
    group { 'A' }
    grade { 5 }
    user { create(:teacher) }
  end
end
