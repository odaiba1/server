class ClassroomsController < ApplicationController
  def new
    @classroom = params[:classroom] ? Classroom.new(classroom_params) : Classroom.new
    if params[:no_model_fields]
    end
  end

  def create

  end

  private

  def classroom_params
    params.require(:classroom).permit()
  end

  def custom_params
    params.require(:no_model_fields).permit()
  end
end
