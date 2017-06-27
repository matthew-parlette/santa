class AssignmentMailer < ApplicationMailer
  default from: 'santa@parlette.us'

  def assignment_created(user)
    @user = User.find(user)
    @assignment = Assignment.where(user: @user, year: Time.zone.now.year).first
    mail(to: @user.email, subject: "Your #{@assignment.year} Secret Santa!")
  end

  def assignment_reminder(user)
    @user = User.find(user)
    @assignment = Assignment.where(user: @user, year: Time.zone.now.year).first
    mail(to: @user.email, subject: "Reminder: Your #{@assignment.year} Secret Santa!",
         template_name: "assignment_created")
  end
end
