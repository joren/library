class User < ApplicationRecord
  has_many :books
  has_many :user_actions
  has_and_belongs_to_many :read_books, join_table: :users_read_books, class_name: "Book", foreign_key: :book_id, association_foreign_key: :user_id

  validates :email, :name, presence: true, uniqueness: true

  before_create :generate_auth_token
  after_create :send_welcome_email

  def generate_auth_token
    self.auth_token = SecureRandom.uuid
    self.auth_token_expires_at = 24.hours.from_now
  end

  def send_welcome_email
    UserMailer.user_welcome(self).deliver_now
  end
end
