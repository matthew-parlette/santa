class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  has_many :assignments
  has_many :assignment_bans
  accepts_nested_attributes_for :assignment_bans, allow_destroy: true
end
