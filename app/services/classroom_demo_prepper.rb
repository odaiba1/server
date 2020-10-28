class ClassroomDemoPrepper
  def initialize(teacher_email, student_emails, worksheet_urls)
    @teacher_email =  teacher_email
    @student_emails = student_emails
    @worksheet_urls = worksheet_urls
    @group_size =     4
    @work_groups =    []
  end

  def call
    prep_teacher
    prep_classroom_and_students
    create_worksheet_templates
    create_work_groups_and_assign_students
    create_worksheets
    variables_for_mailer
  end

  private

  def prep_teacher
    @teacher = User.find_by(email: @teacher_email, role: 'teacher')
    return if @teacher

    @teacher = User.new(email: @teacher_email,
                        name: @teacher_email.split('@').first,
                        role: 'teacher',
                        password: 'secret')
    return if @teacher.save

    raise StandardError.new(@teacher), 'the selected teacher email address is taken for a student account'
  end

  def prep_classroom_and_students
    @classroom = @teacher.classrooms.first || Classroom.create!(
      grade: 0,
      subject: 'demo',
      group: 'test',
      user: @teacher
    )

    @students = StudentsDemoPrepper.new(@student_emails, @classroom).call
  end

  def create_worksheet_templates
    @worksheet_templates = @worksheet_urls.split(' ').map do |worksheet_url|
      image_url = CloudinaryUploader.new(worksheet_url, nil).call

      worksheet_template = WorksheetTemplate.find_by(image_url: image_url, user: User.first)

      worksheet_template || WorksheetTemplate.create!(
        title: 'Demo Template',
        user: User.first,
        image_url: image_url
      )
    end
  end

  def create_work_groups_and_assign_students
    group_number = @students.size / @group_size + 1
    array_of_students = @students.in_groups(group_number).map(&:compact)

    array_of_students.each do |student_group|
      work_group = create_workgroup(student_group)
      student_group.each do |student|
        StudentWorkGroup.create!(
          student: student,
          work_group: work_group,
          joined: true,
          turn: student_group.index(student).zero?
        )
      end
    end
  end

  def create_workgroup(student_group)
    session_time = 30 * 60_000 # TODO: add option to choose session length
    turn_time = 60_000 # TODO: add option to choose turn time length

    work_group = WorkGroup.create!(
      name: student_group.pluck(:name).join('-'),
      video_call_code: 'abc',
      classroom: @classroom,
      session_time: session_time,
      turn_time: turn_time
    )
    @work_groups << work_group
    work_group
  end

  def create_worksheets
    @work_groups.each do |work_group|
      @worksheet_templates.each do |worksheet_template|
        Worksheet.create!(
          title: 'Demo Worksheet',
          canvas: '',
          worksheet_template: worksheet_template,
          work_group: work_group,
          template_image_url: worksheet_template.image_url
        )
      end
    end
  end

  def variables_for_mailer
    {
      teacher: @teacher,
      students: @students
    }
  end
end
