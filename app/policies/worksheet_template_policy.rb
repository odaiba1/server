class WorksheetTemplatePolicy < ApplicationPolicy
  def index?
    case @user.role
    when 'admin'   then true
    when 'teacher' then @record.user_id == @user.id
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
  alias destroy? index?

  class Scope < Scope
    def resolve
      case @user.role
      when 'admin'   then @scope.all
      when 'teacher' then @scope.where(user_id: @user.id)
      else @scope.where(id: -1)
      end
    end
  end
end
