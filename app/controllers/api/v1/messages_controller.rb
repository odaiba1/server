class Api::V1::MessagesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    @message = Message.new(message_params)
    authorize @message
    if @message.save
      render json: @message
    else
      render_error
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id)
  end

  def render_error
    render json: { errors: @message.errors.full_messages },
           status: :unprocessable_entity
  end
end
