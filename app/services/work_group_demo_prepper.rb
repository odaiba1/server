class WorkGroupDemoPrepper
  def initialize(emails, worksheet_url, start_at, turn_time)
    @emails =        emails
    @worksheet_url = worksheet_url
    @start_at =      start_at
    @turn_time =     turn_time.to_i
  end

  def call
    find_or_create_users
    create_work_group
    assign_students_to_work_group
    create_worksheet
    variables_for_mailer
  end

  private

  def find_or_create_users
    StudentsDemoPrepper.new(@emails, Classroom.first).call
  end

  def create_work_group
    @work_group = WorkGroup.create!(
      name: @users.pluck(:name).join('-'),
      video_call_code: 'abc',
      classroom: Classroom.first,
      session_time: @turn_time * 60_000 * @users.size,
      turn_time: @turn_time * 60_000,
      aasm_state: 'in_progress',
      start_at: @start_at
    )
  end

  def assign_students_to_work_group
    @users.each_with_index do |user, idx|
      StudentWorkGroup.create!(
        student: user,
        work_group: @work_group,
        joined: true,
        turn: (idx % @users.size).zero?
      )
    end
  end

  def create_worksheet
    image_url = CloudinaryUploader.new(@worksheet_url, nil).call

    worksheet_template = WorksheetTemplate.find_by(image_url: image_url, user: User.first)

    worksheet_template ||= WorksheetTemplate.create!(
      title: 'Demo Template',
      user: User.first,
      image_url: image_url
    )

    Worksheet.create!(
      title: 'Demo Worksheet',
      canvas: '',
      worksheet_template: worksheet_template,
      work_group: @work_group,
      template_image_url: image_url
    )
  end

  def variables_for_mailer
    {
      users: @users,
      work_group: @work_group
    }
  end
end
