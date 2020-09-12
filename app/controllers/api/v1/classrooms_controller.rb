class Api::V1::ClassroomsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_classroom, only: %i[show edit update destroy]

  def index
    @classrooms = policy_scope(Classroom)
    parsed_classrooms = @classrooms.map do |classroom|
      classroom = classroom.parse_for_dashboard
    end
    render json: parsed_classrooms.to_json
  end

  def show
    render json: classroom_with_relations
  end

  def edit
    render json: classroom_with_relations
  end

  def update
    if @classroom.update(classroom_params)
      render json: classroom_with_relations
    else
      render_error
    end
  end

  def new
    @classroom = Classroom.new
    authorize @classroom
    render json: @classroom.to_json
  end

  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.user = current_user
    authorize @classroom
    if @classroom.save
      render json: classroom_with_relations
    else
      render_error
    end
  end

  def destroy
    @classroom.destroy
    render json: {}
  end

  private

  def classroom_with_relations
    {
      classroom: @classroom,
      teacher: @classroom.teacher.deep_pluck(:id, :name),
      students: @classroom.students.deep_pluck(:id, :name)
    }.to_json
  end

  def set_classroom
    @classroom = Classroom.find(params[:id])
    authorize @classroom
  end

  def classroom_params
    params.require(:classroom).permit(:name)
  end

  def render_error
    render json: { errors: @classroom.errors.full_messages },
           status: :unprocessable_entity
  end
end
