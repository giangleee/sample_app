class User < ApplicationRecord
  attr_accessor :remember_token

  before_save {downcase_email}

  validates :name, presence: true,
            length: {maximum: Settings.validate.name.length.max}

  validates :email, presence: true,
            length: {maximum: Settings.validate.email.length.max},
            format: {with: Settings.validate.email.regex}, uniqueness: true

  has_secure_password
  validates :password, presence: true,
            length: {minimum: Settings.validate.password.length.min}

  class << self
    # Returns the hash digest of the given string.
    def digest string_param
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string_param, cost
    end

    # Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_digest)
    remember_digest
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false unless remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  private

  def downcase_email
    email.downcase!
  end
end
