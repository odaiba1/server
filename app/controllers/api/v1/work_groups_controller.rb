class Api::V1::WorkGroupsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_and_authorize_classroom, only: %i[new create index]
  before_action :set_and_authorize_work_group, only: %i[show edit update destroy]

  def index
    @work_groups = policy_scope(WorkGroup)
    render json: {
      active_work_groups: @work_groups.active_groups,
      all_work_groups: @work_groups
    }.to_json
  end

  def show
    render json: work_group_with_relations
  end

  def edit
    render json: work_group_with_relations
  end

  def update
    if @work_group.update(work_group_params)
      render json: work_group_with_relations
    else
      render_error
    end
  end

  def new
    @work_group = WorkGroup.new
    authorize @work_group
    render json: @work_group.to_json
  end

  def create
    @work_group = WorkGroup.new(work_group_params)
    @work_group.classroom = @classroom
    authorize @work_group
    if @work_group.save
      render json: work_group_with_relations
    else
      render_error
    end
  end

  def destroy
    @work_group.destroy
    render json: {}
  end

  private

  def work_group_with_relations
    {
      work_group: @work_group,
      teacher: @work_group.classroom.teacher.deep_pluck(:id, :name),
      students: @work_group.student_work_groups.deep_pluck(:turn, :joined, user: %i[id name])
    }.to_json
  end

  def set_and_authorize_work_group
    @work_group = WorkGroup.find(params[:id])
    authorize @work_group
  end

  def work_group_params
    # params.require(:work_group).permit(:name, :classroom_id, :session_time, :aasm_state,
    #                                    :turn_time, :video_call_code, :start_at)
    params.require(:work_group).permit(:name, :classroom_id, :session_time, :session_time,
                                   :turn_time, :video_call_code, :start_at)
  end

  def set_and_authorize_classroom
    @classroom = Classroom.find(params[:classroom_id])
    authorize @classroom, :show?
  end

  def render_error
    render json: { errors: @work_group.errors.full_messages },
           status: :unprocessable_entity
  end
end
