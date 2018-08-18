class Employeeship < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  # User status for listings
  # enum status: { :pending: 0, accepted: 1 }
  enum status: [ :pending, :accepted ]

  # Prevent duplicate for Employeeship
  validates_uniqueness_of :user_id, :scope => [:listing_id]

end
