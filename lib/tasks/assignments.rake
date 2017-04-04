require 'timeout'

namespace :assignments do
  desc "Generate assignments for a year"
  task generate: :environment do
    year = Time.zone.now.year
    if Assignment.where(year: year).empty? then
      puts "Generating assignments for #{year}..."
      users = User.all
      Timeout.timeout(60) do
        users.each do |user|
          begin
            assigned_to_id = nil
            while assigned_to_id.nil? do
              random_user_id = users.sample.id
              assigned_to_id = random_user_id unless AssignmentBan.where(user: user, assigned_to_id: random_user_id).any?
              assigned_to_id = nil if Assignment.where(assigned_to_id: random_user_id, year: year).any?
            end
            Assignment.create!(user: user, assigned_to_id: assigned_to_id, year: year)
          rescue Timeout::Error => e
            puts "Assignment generation timed out! Likely you just need to run this again."
            Assignment.where(year: year).destroy_all
            next # Just exit the rake task at this point
          end
        end
      end
    else
      puts "Assignments already exist for #{year}"
    end
    puts "Assignments generated for #{year}!"
    Rake::Task["assignments:verify"].invoke
  end

  desc "Verify that the assignments for a year are valid (no one is assigned two people, etc)"
  task verify: :environment do
    year = Time.zone.now.year
    puts "Verifying assignments for #{year}..."

    users = User.all
    puts "Checking that each user is only assigned once in #{year}..."
    users.each do |user|
      raise "#{user.email} has multiple users assigned to them!" if (Assignment.where(assigned_to_id: user.id, year: year).count > 1)
    end

    puts "Checking that each user has only one assignment in #{year}..."
    users.each do |user|
      raise "#{user.email} has multiple assignments!" if (Assignment.where(user: user, year: year).count > 1)
    end

    puts "Checking that assignment bans are respected in #{year}..."
    users.each do |user|
      assigned_to_id = Assignment.where(user: user, year: year).first.assigned_to_id
      raise "#{user.email} has been assigned someone on their banned list!" if (AssignmentBan.where(user: user, assigned_to_id: assigned_to_id).count > 0)
    end

    puts "Verification complete!"
  end
end
