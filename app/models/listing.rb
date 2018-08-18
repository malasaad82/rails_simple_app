class Listing < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  has_many :employeeships, :dependent => :destroy
  #has_many :users, through: :employeeships

  has_many :pending_users,   -> {where employeeships: { status: 0 }}, :through => :employeeships, source: :user
  #has_many :requested_users, -> {where employeeships: { status: 1 }}, :through => :employeeships, source: :user
  has_many :accepted_users,  -> {where employeeships: { status: 1 }}, :through => :employeeships, source: :user


  # User owner listing relation
  belongs_to :user

  # For Likes
  has_many :likes

  def employeeship_for_listing(user, listing)
    Employeeship.where(:user_id => user.id , :listing_id => listing.id).first
  end
end
