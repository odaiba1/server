class Api::V1::WorksheetReviewsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    @worksheet_review = WorksheetReview.new(message_params)
    @worksheet_review.worksheet_id = params[:worksheet_id].to_i
    authorize @worksheet_review
    if @worksheet_review.save
      render json: @worksheet_review
    else
      render_error
    end
  end

  private

  def message_params
    params.require(:worksheet_review).permit(:content, :user_id)
  end

  def render_error
    render json: { errors: @worksheet_review.errors.full_messages },
           status: :unprocessable_entity
  end
end
