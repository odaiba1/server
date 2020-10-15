class WorksheetReviewPolicy < ApplicationPolicy

  def create?
    @record.teacher == @user || @user.role == 'admin'
  end

  def update?
    @record.teacher == @user || @user.role == 'admin'
  end

  def destroy?
    @record.teacher == @user || @user.role == 'admin'
  end
end
