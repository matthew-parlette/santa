# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'matthew.parlette@gmail.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user1@santa.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user2@santa.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user3@santa.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user4@santa.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user5@santa.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user6@santa.com', password: 'password', password_confirmation: 'password')

User.all.each do |user|
  user.assignment_bans.create!(:assigned_to => user)
  user.assignment_bans.create!(:assigned_to => User.find(user.id + 1)) unless user.id == User.last.id
end
