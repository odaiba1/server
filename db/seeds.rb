p 'emptying database'

StudentWorkGroup.destroy_all
GroupWorkSheet.destroy_all
StudentClassroom.destroy_all
Worksheet.destroy_all
WorkGroup.destroy_all
Classroom.destroy_all
User.destroy_all

p 'creating teacher'

User.create!(name: Faker::Name.name, email: 'teacher@gmail.com', password: 'supersecret', role: 1)

p "Finished creating #{User.where(role: 1).size} Teachers"

p 'creating students'

20.times do
  name = Faker::Name.name
  User.create!(name: name, email: name.split.join('') + '@gmail.com', password: 'secret')
end

p "Finished creating #{User.where(role: 0).size} students"

p 'creating classroom'

Classroom.create!(
  user_id: User.where(role: 1).first.id,
  name: '4B English'
)

p "Finished creating #{Classroom.count} classrooms"

p 'assigning students to classrooms'

students = User.where(role: 0)
students.each do |user|
  StudentClassroom.create!(user: user, classroom: Classroom.first)
end

p 'Finished assigning students to classrooms'

p 'creating work groups'

(1..5).to_a.each do |number|
  WorkGroup.create!(
    name: "Group #{number}",
    video_call_code: 'abc',
    classroom: Classroom.first,
    session_time: 1_200_000,
    turn_time: 3000,
    score: 0,
    answered: 0,
    aasm_state: 'in_progress',
    start_at: DateTime.new(2030, 1, 1, 10, 30)
  )
end

p "Finished creating #{WorkGroup.count} work groups"

p 'assigning students to workgroups'

work_groups = WorkGroup.all
students.each_with_index do |student, index|
  StudentWorkGroup.create!(
    student: student,
    work_group: work_groups[index / 4],
    joined: true,
    turn: (index % 4).zero?
  )
end

p 'Finished assigning students to work groups'

p 'creating worksheets'

Worksheet.create!(
  display_content: {
    headers: ['japanese', 'english', 'past', 'past participle'],
    example: ['始める', 'begin', 'began', 'begun'],
    1 => ['走る', 'run', false, false],
    2 => ['言う', 'say', false, false],
    3 => ['見る', 'see', false, false],
    4 => ['売る', 'sell', false, false],
    5 => ['送る', 'send', false, false],
    6 => ['見せる', 'show', false, false],
    7 => ['歌う', 'sing', false, false],
    8 => ['座る', 'sit', false, false],
    9 => ['話す', 'speak', false, false],
    10 => ['読む', 'read', false, false]
  }.to_json,
  correct_content: {
    headers: ['japanese', 'english', 'past', 'past participle'],
    example: ['始める', 'begin', 'began', 'begun'],
    1 => ['走る', 'run', 'ran', 'run'],
    2 => ['言う', 'say', 'said', 'said'],
    3 => ['見る', 'see', 'saw', 'seen'],
    4 => ['売る', 'sell', 'sold', 'sold'],
    5 => ['送る', 'send', 'sent', 'sent'],
    6 => ['見せる', 'show', 'showed', 'shown'],
    7 => ['歌う', 'sing', 'sang', 'sung'],
    8 => ['座る', 'sit', 'sat', 'sat'],
    9 => ['話す', 'speak', 'spoke', 'spoken'],
    10 => ['読む', 'read', 'read', 'read']
  }.to_json,
  name: 'Past Tense'
)

p "Finished creating #{Worksheet.count} worksheets"

p 'assigning worksheets to work groups'

work_groups.each do |work_group|
  GroupWorkSheet.create!(worksheet: Worksheet.first, work_group: work_group)
end

p 'Finished assigning worksheets to work groups'

p 'finished'
