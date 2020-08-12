class WorksheetsController < ApplicationController
  acts_as_token_authentication_handler_for User

  def index
    @work_group = WorkGroup.find(params[:work_group_id])
    authorize @work_group
    @worksheets = policy_scope(Worksheet)
    render json: @worksheets.to_json
  end
end
