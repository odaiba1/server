json.extract! @classroom, :id, :user_id, :class_time
json.students @classroom.students do |student|
  json.extract! student, :id, :name, :active_student_workgroups
end
