# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'matthew.parlette@gmail.com', password: 'password', password_confirmation: 'password')
User.create!(first_name: 'user1', last_name: 'lastname1', email: 'user1@santa.com', password: 'password', password_confirmation: 'password')
User.create!(first_name: 'user2', last_name: 'lastname2', email: 'user2@santa.com', password: 'password', password_confirmation: 'password')
User.create!(first_name: 'user3', last_name: 'lastname3', email: 'user3@santa.com', password: 'password', password_confirmation: 'password')
User.create!(first_name: 'user4', last_name: 'lastname4', email: 'user4@santa.com', password: 'password', password_confirmation: 'password')
User.create!(first_name: 'user5', last_name: 'lastname5', email: 'user5@santa.com', password: 'password', password_confirmation: 'password')
User.create!(first_name: 'user6', last_name: 'lastname6', email: 'user6@santa.com', password: 'password', password_confirmation: 'password')

User.all.each do |user|
  user.assignment_bans.create!(:assigned_to => user)
  user.assignment_bans.create!(:assigned_to => User.find(user.id + 1)) unless user.id == User.last.id
end

# Previous year's assignments
Assignment.create!(user_id: 1, assigned_to_id: 3, year: 2016)
Assignment.create!(user_id: 2, assigned_to_id: 4, year: 2016)
Assignment.create!(user_id: 3, assigned_to_id: 5, year: 2016)
Assignment.create!(user_id: 4, assigned_to_id: 6, year: 2016)
Assignment.create!(user_id: 5, assigned_to_id: 1, year: 2016)
Assignment.create!(user_id: 6, assigned_to_id: 2, year: 2016)

# Ideas
Idea.create!(name: 'idea 1', user_id: 1, created_by_id: 1, private: false)
Idea.create!(name: 'idea 2', user_id: 1, created_by_id: 2, private: false)
Idea.create!(name: 'idea 3', user_id: 2, created_by_id: 3, private: false)
Idea.create!(name: 'idea 4', user_id: 3, created_by_id: 1, private: false)
Idea.create!(name: 'idea 5', user_id: 4, created_by_id: 1, private: false)
Idea.create!(name: 'idea 6', user_id: 5, created_by_id: 1, private: false)
Idea.create!(name: 'private idea 1', user_id: 6, created_by_id: 3, private: true)
