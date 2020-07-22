class ClassroomPolicy < ApplicationPolicy
  # admin all permit
  # teacher all permit for own classrooms
  # students permit only show and index
end
