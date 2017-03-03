class Assignment < ApplicationRecord
  belongs_to :user
  has_one :user, as: :assignment
end
