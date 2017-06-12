class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_to, :class_name => "User"
end
