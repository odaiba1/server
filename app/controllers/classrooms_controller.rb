class ClassroomsController < ApplicationController
  def index
    @classrooms = policy_scope(Classroom)
    respond_to do |format|
      format.json { render json: @classrooms.to_json }
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def new
  end

  def create
  end

  def delete
  end


end
