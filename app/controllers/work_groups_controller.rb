class WorkGroupsController < ApplicationController
  def new
    @work_group = WorkGroup.new
    @worksheet_urls = WorksheetTemplate.all.pluck(:image_url).uniq.select do |url|
      url.include?('res.cloudinary.com/naokimi')
    end
  end

  def create
    vars_for_mailer = WorkGroupDemoPrepper.new(
      custom_params[:emails],
      custom_params[:worksheet_url],
      work_group_params[:start_at],
      work_group_params[:turn_time]
    ).call

    if vars_for_mailer
      # flash notice
      vars_for_mailer[:users].each do |user|
        InvitationMailer.with(user: user, work_group: vars_for_mailer[:work_group]).demo_invite.deliver_later
      end
    else
      render :new
    end
  end

  private

  def work_group_params
    params.require(:work_group).permit(:turn_time, :start_at)
  end

  def custom_params
    params.require(:no_model_fields).permit(:emails, :worksheet_url)
  end
end
