require 'timeout'

namespace :assignments do
  desc "Generate assignments for a year"
  task generate: :environment do
    year = Time.zone.now.year
    puts "Assignments already exist for #{year}" unless Assignment.where(year: year).empty?
    while Assignment.where(year: year).empty? do
      puts "Generating assignments for #{year}..."
      users = User.all
      users.each do |user|
        assigned_to_id = nil
        attempts = 0
        while assigned_to_id.nil? do
          attempts += 1
          random_user_id = users.sample.id
          assigned_to_id = random_user_id unless AssignmentBan.where(user: user, assigned_to_id: random_user_id).any?
          assigned_to_id = nil if Assignment.where(assigned_to_id: random_user_id, year: year).any?
          break if attempts > 30
        end
        Assignment.create!(user: user, assigned_to_id: assigned_to_id, year: year) unless assigned_to_id.nil?
      end
      if Assignment.where(year: year).count != User.count then
        puts "Assignment generation failed! Retrying..."
        Assignment.where(year: year).destroy_all
      end
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
