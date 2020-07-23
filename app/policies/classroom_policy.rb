class ClassroomPolicy < ApplicationPolicy
  # admin all permit
  # teacher all permit for own classrooms
  # students permit only show and index
  def index?
    case @user.role
    when 'admin' then true
    when 'teacher'

    when 'student'

    else
      false
    end
  end

  def create?

  end

  def update?

  end

  alias show? index?
  # alias :new?, :create?
end
