class WorksheetReviewPolicy < ApplicationPolicy

  def create?
    @record.teacher == @user || @user.role == 'admin'
  end

  alias update? create?
  alias destroy? create?
end
