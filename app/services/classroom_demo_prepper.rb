class ClassroomDemoPrepper
  def initialize(teacher_email, student_emails, worksheet_urls)
    @teacher_email =  teacher_email
    @student_emails = student_emails
    @worksheet_urls = worksheet_urls
  end

  def call
    prep_teachers_and_classroom
    prep_students
    prep_worksheet_templates


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

  private

  def prep_teachers_and_classroom
    @teacher = User.find_by(email: @teacher_email, role: 'teacher')
    unless @teacher
      @teacher = User.new(email: @teacher_email, name: @teacher_email.split('@').first, role: 'teacher')
      return @teacher.errors.messages unless @teacher.save
    end

    @classroom = @teacher.classrooms.first || Classroom.create!(
      grade: 0,
      subject: 'demo',
      group: 'test',
      user: @teacher
    )
  end

  def prep_worksheet_templates
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

  def prep_students
    @students = StudentsDemoPrepper.new(@student_emails, @classroom).call
  end

  def create_work_groups
    @work_groups = (@students.size / 4 + 1).times do
      WorkGroup.create!(
        name: @users.pluck(:name).join('-'),
        video_call_code: 'abc',
        classroom: @classroom
      )
    end
  end
end
