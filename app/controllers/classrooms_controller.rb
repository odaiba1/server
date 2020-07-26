class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [ :show, :update ]

  def index
    @classrooms = policy_scope(Classroom)
    render json: @classrooms.to_json
  end

  def show
    render json: @classroom.to_json
  end

  def edit

  end

  def update
    if @classroom.update(classroom_params)
      render json: @classroom.to_json
    else
      render_error
    end
  end

  def new
  end

  def create
  end

  def delete
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
    authorize @classroom  # For Pundit
  end

  def classroom_params
    params.require(:classroom).permit(:name)
  end

  def render_error
    render json: { errors: @classroom.errors.full_messages },
      status: :unprocessable_entity
  end

end
