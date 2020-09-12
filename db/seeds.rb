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
User.create!(name: 'Ms. Tachibana', email: 'tachibanar@gmail.com', password: 'supersecret', role: 1)
User.create!(name: 'Mr. Murakami', email: 'murakami@gmail.com', password: 'supersecret', role: 1)
User.create!(name: 'Ms. Hayashi', email: 'hayashi@gmail.com', password: 'supersecret', role: 1)
User.create!(name: 'Ms. Dedachi', email: 'dedachi@gmail.com', password: 'supersecret', role: 1)
User.create!(name: 'Mr. Murata', email: 'murata@gmail.com', password: 'supersecret', role: 1)

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

subjects = ['English', 'Maths', 'Science', 'Geography', 'History']
groups = ['A', 'B', 'C']

subjects.each do |subject|
  groups.each do |group|
    Classroom.create!(
      user_id: User.where(role: 1)[(rand(User.where(role: 1).length))].id,
      group: "Class #{group}",
      subject: subject
    )
  end
end

p "Finished creating #{Classroom.count} classrooms"

p 'assigning students to classrooms'

students = User.where(role: 0)

Classroom.all.each do |classroom|
  students = User.where(role: 0)
  20.times do
    index = rand(students.length)
    student = students[index]
    StudentClassroom.create!(
      user: student,
      classroom: classroom
    )
  end
end

p 'Finished assigning students to classrooms'

p 'creating work groups'

(1..5).to_a.each do |number|
  WorkGroup.create!(
    name: "Group #{number}",
    video_call_code: 'abc',
    classroom: Classroom.first,
    session_time: 1_200_000, # time in miliseconds, 60000 == 1 minute
    turn_time: 300_000, # time in miliseconds, 60000 == 1 minute
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
  session_time: 1_200_000, # time in miliseconds, 60000 == 1 minute
  turn_time: 300_000, # time in miliseconds, 60000 == 1 minute
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

WorksheetTemplate.create!(
  title: 'Template 1',
  user: User.first,
  image_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'
)
WorksheetTemplate.create!(
  title: 'Template 2',
  user: User.second,
  image_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'
)

p "Finished creating #{WorksheetTemplate.count} worksheets"

p 'assigning worksheets to work groups'

work_groups.each_with_index do |work_group, idx|
  template = idx == WorkGroup.count - 1 ? WorksheetTemplate.last : WorksheetTemplate.first
  Worksheet.create!(
    title: "Worksheet #{idx}",
    canvas: '',
    worksheet_template: template,
    work_group: work_group,
    template_image_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'
  )
end

p 'Finished assigning worksheets to work groups'

p 'finished'
