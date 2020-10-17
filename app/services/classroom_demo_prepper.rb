class ClassroomDemoPrepper
  def initialize(teacher_email, student_emails, worksheet_templates)
    @teacher_email =       teacher_email
    @student_emails =      student_emails
    @worksheet_templates = worksheet_templates
  end

  def call
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

    StudentsDemoPrepper.new(@student_emails, @classroom).call
  end
end
