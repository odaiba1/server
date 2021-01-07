json.work_group do
  json.merge! @work_group.attributes
end

json.teacher do
  json.extract! @work_group.classroom.teacher, :id, :name
end

json.students @work_group.student_work_groups do |student|
  json.extract! student, :turn, :joined
  # json.merge! student.attributes
  # json.extract!
  json.user do
    json.extract! student.user, :id, :name
  end
end
