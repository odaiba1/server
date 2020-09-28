puts 'Welcome to instance creation script'
puts 'Please write names of members who will participate on demo'
puts 'Please separate all names by a space'
puts '(e.g.: Paulo Ivan David)'
print '> '
users = gets.chomp.split(' ').map(&:capitalize)
new_users = []

users.each do |name|
  user = User.find_by_name(name)
  next if user

  new_user = User.new(name: name, email: name.downcase + '@gmail.com', password: 'secret')
  new_user.save!
  new_users << new_user
end

users = users.map { |name| User.find_by_name(name) }

new_users.each do |user|
  StudentClassroom.create!(user: user, classroom: Classroom.first)
end

puts "Choose turn time in minutes for #{users.size} users"
print '> '
turn_time = gets.chomp.to_i

puts 'Choose in how many minutes the lesson should start'
print '> '
start_at = gets.chomp.to_i

WorkGroup.create!(
  name: users.join('-'),
  video_call_code: 'abc',
  classroom: Classroom.first,
  session_time: turn_time * 60_000 * users.size,
  turn_time: turn_time * 60_000,
  aasm_state: 'in_progress',
  start_at: Time.current + start_at.minutes
)

users.each_with_index do |user, idx|
  StudentWorkGroup.create!(
    student: user,
    work_group: WorkGroup.last,
    joined: true,
    turn: (idx % users.size).zero?
  )
end

puts 'Paste url for worksheet template'
print '> '
image_url = gets.chomp
image_url = CloudinaryUploader.new(image_url, nil).call

WorksheetTemplate.create!(
  title: 'Demo Template',
  user: User.first,
  image_url: image_url
)

Worksheet.create!(
  title: 'Demo Worksheet',
  canvas: '',
  worksheet_template: WorksheetTemplate.last,
  work_group: WorkGroup.last,
  template_image_url: image_url
)

p 'Finished!'
workgroup = WorkGroup.last
p "Find the url at https://odaiba-app.netlify.app/classrooms/#{workgroup.classroom_id}/work_groups/#{workgroup.id}"
