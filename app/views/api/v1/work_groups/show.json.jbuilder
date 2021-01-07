json.work_group do
  json.merge! @work_group.attributes
  json.student_initiated @work_group.student_initiated
end

json.teacher do
  json.extract! @work_group.classroom.teacher, :id, :name
end

json.students @work_group.student_work_groups do |student|
  json.extract! student, :turn, :joined
  json.user do
    json.extract! student.user, :id, :name
  end
end
