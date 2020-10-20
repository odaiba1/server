class ClassroomDemoPrepper
  def initialize(teacher_email, student_emails, worksheet_urls)
    @teacher_email =  teacher_email
    @student_emails = student_emails
    @worksheet_urls = worksheet_urls
    @group_size =     4
    @work_groups =    []
  end

  def call
    prep_users_and_classroom
    create_worksheet_templates
    create_work_groups
    create_worksheets
  end

  private

  def prep_users
    @teacher = User.find_by(email: @teacher_email, role: 'teacher')
    unless @teacher
      @teacher = User.new(email: @teacher_email,
                          name: @teacher_email.split('@').first,
                          role: 'teacher',
                          password: 'secret')
      return @teacher.errors.messages unless @teacher.save
    end

    @classroom = @teacher.classrooms.first || Classroom.create!(
      grade: 0,
      subject: 'demo',
      group: 'test',
      user: @teacher
    )

    @students = StudentsDemoPrepper.new(@student_emails, @classroom).call
  end

  def create_worksheet_templates
    @worksheet_templates = @worksheet_urls.map do |worksheet_url|
      image_url = CloudinaryUploader.new(worksheet_url, nil).call

      worksheet_template = WorksheetTemplate.find_by(image_url: image_url, user: User.first)

      worksheet_template || WorksheetTemplate.create!(
        title: 'Demo Template',
        user: User.first,
        image_url: image_url
      )
    end
  end

  def create_work_groups
    group_number = @students.size / @group_size + 1
    array_of_students = @students.in_groups(group_number).map(&:compact)
    array_of_students.each do |student_group|
      work_group = WorkGroup.create!(name: student_group.pluck(:name).join('-'),
                                     video_call_code: 'abc',
                                     classroom: @classroom)
      @work_groups << work_group
      student_group.each do |student|
        StudentWorkGroup.create!(student: student,
                                 work_group: work_group,
                                 joined: true,
                                 turn: student_group.index(student).zero?)
      end
    end
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
end
