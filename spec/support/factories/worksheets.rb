FactoryBot.define do
  factory :worksheet do
    name { 'Test' }
    display_content do
      {
        headers: ['japanese', 'english', 'past', 'past participle'],
        example: ['始める', 'begin', 'began', 'begun'],
        1 => ['走る', 'run', false, false]
      }.to_json
    end
    correct_content do
      {
        headers: ['japanese', 'english', 'past', 'past participle'],
        example: ['始める', 'begin', 'began', 'begun'],
        1 => ['走る', 'run', 'ran', 'run']
      }.to_json
    end
    association :user
  end
end
