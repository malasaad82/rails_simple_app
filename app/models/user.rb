class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name,  presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
   									format: { with: VALID_EMAIL_REGEX },
   									uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :employeeships, :dependent => :destroy
  #has_many :listings, through: :employeeships

  has_many :pending_listings,   -> {where employeeships: { status: 0 }}, :through => :employeeships, source: :listing
  #has_many :requested_listings, -> {where employeeships: { status: 1 }}, :through => :employeeships, source: :listing
  has_many :accepted_listings,  -> {where employeeships: { status: 1 }}, :through => :employeeships, source: :listing

  # User owner listing relation
  has_many :listings, ->{ order "created_at Desc" }

  # For Likes
  has_many :likes

  # enum status: { :pending: 0, accepted: 1 }
  # User role for listings 0 , 1
  enum role: [ :visitor, :beautician ]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :visitor
  end

  def has_like?(listing)
    likes.find_by_listing_id(listing.id)
  end

  # Adding a digest method for use in fixtures
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token. used for remember user login even if close browser
  def User.new_token
    SecureRandom.urlsafe_base64
  end


  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end


  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  # Listings methods
  def listing_already_added?(listing_id)
    listing = Listing.where(id: listing_id).first
    return false unless listing
    employeeships.where(listing_id: listing_id).exists?
  end

  # def under_listing_limit?
  #   (employeeships.count < 10)
  # end

  def can_join_listing?(listing_id)
    #under_listing_limit? &&
    !listing_already_added?(listing_id)
  end

  def user_already_added?(user_id, listing_id)
    user = User.find_by(id: user_id)
    listing = Listing.find_by(id: listing_id)
    return false unless user || listing
    employeeships.where(user_id: user_id, listing_id: listing_id).exists?
  end

  def can_add_user?(user_id, listing_id)
    #under_listing_limit? &&
    !user_already_added?(user_id, listing_id)
  end

  def employeeship_for_listing(user, listing)
    Employeeship.where(:user_id => user.id , :listing_id => listing.id).first
  end

  # def can_edit? listing
  #   # listing.user_id == self.id
  #   listing.user_id == self.id 
  # end

  private

    # Converts email to all lower-case.
    def downcase_email
      # self.email = email.downcase!
      self.email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
