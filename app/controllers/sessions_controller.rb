class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      @current_user = user

      render json: {
        id: @current_user.id,
        name: @current_user.name,
        role: @current_user.role,
        token: generate_jwt(@current_user.id)
      }
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private

  def generate_jwt(user_id)
    JWT.encode({id: user_id,
                exp: 60.days.from_now.to_i},'secret')
  end
end


