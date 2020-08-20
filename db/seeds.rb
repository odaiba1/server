require 'database_cleaner/active_record'
p 'emptying database'

StudentWorkGroup.destroy_all
StudentClassroom.destroy_all
Worksheet.destroy_all
WorksheetTemplate.destroy_all
WorkGroup.destroy_all
Classroom.destroy_all
User.destroy_all

DatabaseCleaner.allow_production = true
DatabaseCleaner.allow_remote_database_url = true
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

p 'creating teachers'

User.create!(name: Faker::Name.name, email: 'teacher@gmail.com', password: 'supersecret', role: 1)
User.create!(name: Faker::Name.name, email: 'sub-teacher@gmail.com', password: 'supersecret', role: 1)

p "Finished creating #{User.where(role: 1).size} Teachers"

p 'creating students'

User.create!(name: 'Paulo', email: 'paulo@gmail.com', password: 'secret')
User.create!(name: 'Dzakki', email: 'dzakki@gmail.com', password: 'secret')
User.create!(name: 'Ann', email: 'ann@gmail.com', password: 'secret')
User.create!(name: 'Myra', email: 'myra@gmail.com', password: 'secret')

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
Classroom.create!(
  user_id: User.where(role: 1).last.id,
  name: '1C Math'
)

p "Finished creating #{Classroom.count} classrooms"

p 'assigning students to classrooms'

students = User.where(role: 0).limit(20)
students.each do |user|
  StudentClassroom.create!(user: user, classroom: Classroom.first)
end

(User.where(role: 0) - students).each do |user|
  StudentClassroom.create!(user: user, classroom: Classroom.last)
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

WorkGroup.create!(
  name: "Group 1",
  video_call_code: 'xyz',
  classroom: Classroom.last,
  session_time: 1_200_000,
  turn_time: 3000,
  score: 0,
  answered: 0,
  aasm_state: 'in_progress',
  start_at: DateTime.new(2030, 1, 1, 10, 30)
)

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
(User.where(role: 0) - students).each_with_index do |student, index|
  StudentWorkGroup.create!(
    student: student,
    work_group: WorkGroup.last,
    joined: true,
    turn: (index % 4).zero?
  )
end

p 'Finished assigning students to work groups'

p 'creatin worksheet templates'

WorksheetTemplate.create!(title: 'Template 1', user: User.first, image_url: 'xxx')
WorksheetTemplate.create!(title: 'Template 2', user: User.second, image_url: 'xxx')

p "Finished creating #{WorksheetTemplate.count} worksheets"

p 'assigning worksheets to work groups'

work_groups.each_with_index do |work_group, idx|
  template = idx == WorkGroup.count - 1 ? WorksheetTemplate.last : WorksheetTemplate.first
  Worksheet.create!(title: "Worksheet #{idx}", worksheet_template: template, work_group: work_group, image_url: 'xxx')
end

p 'Finished assigning worksheets to work groups'

p 'finished'
