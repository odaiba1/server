class WorksheetPolicy < ApplicationPolicy
  def index?
    case @user.role
    when 'admin'   then true
    when 'teacher' then @record.worksheet_template.user_id == @user.id
    when 'student' then @record.work_group.students.include?(@user)
    else false
    end
  end

  def create?
    %w[admin teacher].include?(@user.role)
  end

  alias show? index?
  alias new? create?
  alias edit? index?
  alias update? index?

  class Scope < Scope
    def resolve
      case @user.role
      when 'admin'   then @scope.all
      when 'teacher' then @scope.where(worksheet_template_id: @user.worksheet_templates.ids)
      when 'student'
        @scope.joins(:work_group).joins(work_group: :users).where(work_group: { users: { id: @user.id } })
      else @scope.where(id: -1)
      end
    end

    def dashboard_scope
      case @user.role
      when 'admin'   then @scope.all
      # when 'teacher' then @scope.where(worksheet_template_id: @user.worksheet_templates.ids) #TODO: Check the teacher dashboard on frontend and set correct scope
      when 'student' then @user.worksheets
      else @scope.where(id: -1)
      end
    end
  end
end
