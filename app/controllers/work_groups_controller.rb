class WorkGroupsController < ApplicationController
  def new
    @work_group = params[:work_group] ? WorkGroup.new(work_group_params) : WorkGroup.new
    if params[:no_model_fields]
      @emails =     custom_params[:emails]
      @urls =       custom_params[:worksheet_url]
      @start_time = custom_params[:start_time]
      @start_date = custom_params[:start_date]
    end
    @worksheet_urls = WorksheetTemplate.where(user_id: 1).pluck(:image_url).select do |url|
      url.include?('res.cloudinary.com/naokimi')
    end
  end

  def create
    return redirect_with_params('Please input at least 2 email addresses') if custom_params[:emails].split(' ').size < 2

    begin
      users_and_work_groups = vars_for_mailer
      users_and_work_groups[:users].each do |user|
        InvitationMailer.with(user: user, work_group: users_and_work_groups[:work_group]).demo_invite.deliver_later
      end
      redirect_to new_work_group_path, notice: 'Invitations sent'
    rescue StandardError => e
      redirect_with_params(e.message)
    end
  end

  private

  def work_group_params
    params.require(:work_group).permit(:turn_time)
  end

  def custom_params
    params.require(:no_model_fields).permit(:emails, :worksheet_url, :start_time, :start_date)
  end

  def redirect_with_params(message)
    redirect_to new_work_group_path(work_group: work_group_params, no_model_fields: custom_params), notice: message
  end

  def vars_for_mailer
    start_time = (custom_params[:start_date] + ' ' + custom_params[:start_time]).to_datetime.in_time_zone
    start_time -= 9.hours if Rails.env == 'production' # heroku just keeps adding 9 hours, dont now why

    WorkGroupDemoPrepper.new(
      custom_params[:emails],
      custom_params[:worksheet_url],
      start_time,
      work_group_params[:turn_time]
    ).call
  end
end
