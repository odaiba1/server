class WorkGroupDemoPrepper
  def initialize(emails, worksheet_url, start_at, turn_time)
    @emails =        emails
    @worksheet_url = worksheet_url
    @start_at =      start_at
    @turn_time =     turn_time
  end

  def call
    find_or_create_users
    create_work_groups
    assign_students_to_work_groups
    create_worksheet
    variables_for_mailer
  end

  private

  def find_or_create_users
    new_users = []
    @users = @emails.split(' ').map do |email|
      user = User.find_by_email(email)

      if user
        user
      else
        new_user = User.new(name: email.split('@').first, email: email, password: 'secret')
        new_user.save!
        new_users << new_user
        new_user
      end
    end

    new_users.each do |user|
      StudentClassroom.create!(user: user, classroom: Classroom.first)
    end
  end

  def create_work_groups
    @work_group = WorkGroup.create!(
      name: @users.join('-'),
      video_call_code: 'abc',
      classroom: Classroom.first,
      session_time: @turn_time * @users.size,
      turn_time: @turn_time,
      aasm_state: 'in_progress',
      start_at: @start_at
    )
  end

  def assign_students_to_work_groups
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

    worksheet_template = WorksheetTemplate.create!(
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
