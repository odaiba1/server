class StudentsDemoPrepper
  def initialize(emails, classroom)
    @emails =    emails
    @classroom = classroom
  end

  def call
    prep_students

    assigned_students = @classroom.students
    @students.each do |user|
      StudentClassroom.create!(user: user, classroom: @classroom) unless assigned_students.include?(user)
    end

    @students
  end

  private

  def prep_students
    @students = @emails.split(' ').map do |email|
      new_email = email.split('@').join('+student@')
      student = User.find_by_email(new_email)
      user = User.find_by_email(email)
      if student
        student
      elsif user&.role == 'student'
        user
      else
        User.create!(name: email.split('@').first, email: user ? email : new_email, password: 'secret')
      end
    end
  end
end
