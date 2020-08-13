class WorkGroupPolicy < ApplicationPolicy
  def index?
    case @user.role
    when 'admin'   then true
    when 'teacher' then @record.classroom.user_id == @user.id
    when 'student' then @record.students.include?(@user)
    else false
    end
  end

  def create?
    %w[admin teacher].include?(@user.role)
  end

  def update?
    case @user.role
    when 'admin'   then true
    when 'teacher' then @record.classroom.user_id == @user.id
    else false
    end
  end

  alias show? index?
  alias new? create?
  alias edit? update?
  alias destroy? update?

  class Scope < Scope
    def resolve
      case @user.role
      when 'admin'   then @scope.all
      when 'teacher' then @scope.where(classroom_id: @user.classrooms.ids)
      when 'student' then @scope.where(id: @user.work_groups.ids)
      else @scope.where(id: -1)
      end
    end
  end
end
