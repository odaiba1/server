class StudentsDemoPrepper
  def initialize(emails, classroom)
    @emails =    emails
    @classroom = classroom
  end

  def call
    @users = @emails.split(' ').map do |email|
      user = User.find_by_email(email)
      user || User.create!(name: email.split('@').first, email: email, password: 'secret')
    end

    assigned_students = @classroom.students
    @users.each do |user|
      StudentClassroom.create!(user: user, classroom: @classroom) unless assigned_students.include?(user)
    end
  end
end
