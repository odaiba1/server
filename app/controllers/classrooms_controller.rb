class ClassroomsController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :set_classroom, only: %i[show edit update destroy]

  def index
    @classrooms = policy_scope(Classroom)
    render json: @classrooms.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def show
    render json: @classroom.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def edit
    render json: @classroom.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def update
    if @classroom.update(classroom_params)
      render json: @classroom.to_json
    else
      render_error
    end
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def new
    @classroom = Classroom.new
    authorize @classroom
    render json: @classroom.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.user = current_user
    authorize @classroom
    if @classroom.save
      render json: @classroom.to_json
    else
      render_error
    end
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def destroy
    @classroom.destroy
    render json: {}
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  private

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
