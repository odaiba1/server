json.extract! @classroom, :id, :class_time

json.teacher do
  json.extract! @classroom.teacher, :id, :name
end

json.students @classroom.students do |student|
  json.extract! student, :id, :name
  json.active_groups student.active_student_workgroups
end
