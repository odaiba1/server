class WorkGroupsController < ApplicationController
  def new
    instances_for_new_form
  end

  def create
    users_and_work_groups = vars_for_mailer
    if users_and_work_groups
      users_and_work_groups[:users].each do |user|
        InvitationMailer.with(user: user, work_group: users_and_work_groups[:work_group]).demo_invite.deliver_later
      end
      instances_for_new_form
      render :new, notice: 'Invitations sent'
    else
      instances_for_new_form
      render :new, notice: errors.messages
    end
  end

  private

  def work_group_params
    params.require(:work_group).permit(:turn_time, :start_at)
  end

  def custom_params
    params.require(:no_model_fields).permit(:emails, :worksheet_url)
  end

  def instances_for_new_form
    @work_group = WorkGroup.new
    @worksheet_urls = WorksheetTemplate.all.pluck(:image_url).uniq.select do |url|
      url.include?('res.cloudinary.com/naokimi')
    end
  end

  def vars_for_mailer
    start_time = Time.new(
      work_group_params['start_at(1i)'],
      work_group_params['start_at(2i)'],
      work_group_params['start_at(3i)'],
      work_group_params['start_at(4i)'],
      work_group_params['start_at(5i)']
    )

    WorkGroupDemoPrepper.new(
      custom_params[:emails],
      custom_params[:worksheet_url],
      start_time,
      work_group_params[:turn_time]
    ).call
  end
end
