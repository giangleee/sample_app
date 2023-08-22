class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.validate.name.length.max}

  validates :email, presence: true,
            length: {maximum: Settings.validate.email.length.max},
            format: {with: Settings.validate.email.regex}, uniqueness: true

  has_secure_password
  validates :password, presence: true,
            length: {minimum: Settings.validate.password.length.min}

  private

  def downcase_email
    email.downcase!
  end
end
