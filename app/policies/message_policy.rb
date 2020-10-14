class MessagePolicy < ApplicationPolicy

  def create?
    %w[admin teacher].include?(@user.role)
  end

  # class Scope < Scope
  #   def resolve
  #     case @user.role
  #     when 'admin'   then @scope.all
  #     when 'teacher' then @scope.where(classroom_id: @user.classrooms.ids)
  #     when 'student' then @scope.where(id: @user.work_groups.ids)
  #     else @scope.where(id: -1)
  #     end
  #   end
  # end
end
