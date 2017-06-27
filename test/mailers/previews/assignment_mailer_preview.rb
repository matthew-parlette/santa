# Preview all emails at http://localhost:3000/rails/mailers/assignment_mailer
class AssignmentMailerPreview < ActionMailer::Preview
  def assignment_created_preview
      AssignmentMailer.assignment_created(User.first)
    end
end
