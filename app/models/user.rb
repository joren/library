class User < ApplicationRecord
  has_many :books

  validates :email, :name, presence: true, uniqueness: true

  before_create :generate_auth_token
  after_create :send_welcome_email

  def generate_auth_token
    self.auth_token = SecureRandom.uuid
    self.auth_token_expires_at = 24.hours.from_now
  end

  def send_welcome_email
    Mailer.user_welcome(self).deliver_now
  end
end
