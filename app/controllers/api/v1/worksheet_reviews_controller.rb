class Api::V1::WorksheetReviewsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_and_authorize_worksheet_review, only: %i[update destroy]


  def create
    @worksheet_review = WorksheetReview.new(worksheet_review_params)
    @worksheet_review.worksheet_id = params[:worksheet_id]
    authorize @worksheet_review
    if @worksheet_review.save
      render json: @worksheet_review
    else
      render_error
    end
  end

  def update
    if @worksheet_review.update(worksheet_review_params)
      render json: @worksheet_review
    else
      render_error
    end
  end

  def destroy
    if @worksheet_review.destroy
      render json: {}
    else
      render_error
    end
  end

  private

  def worksheet_review_params
    params.require(:worksheet_review).permit(:content, :user_id)
  end

  def render_error
    render json: { errors: @worksheet_review.errors.full_messages },
           status: :unprocessable_entity
  end

  def set_and_authorize_worksheet_review
    @worksheet_review = WorksheetReview.find(params[:id])
    authorize @worksheet_review
  end
end
