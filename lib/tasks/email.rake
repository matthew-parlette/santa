namespace 'email:assignments' do
  desc "Email users that an assignment was created"
  task created: :environment do
    User.all.each do |u|
      AssignmentMailer.assignment_created(u.id).deliver_now
    end
  end

  desc "Send a reminder email for each user's assignment"
  task reminder: :environment do
    User.all.each do |u|
      AssignmentMailer.assignment_reminder(u.id).deliver_now
    end
  end
end
