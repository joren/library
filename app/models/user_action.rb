class UserAction < ApplicationRecord
  belongs_to :user
  belongs_to :book

  ACTIONS = %w(book_read book_downloaded book_uploaded).freeze

  ACTIONS.each do |action|
    self.class.define_method "#{action}!" do |user:, book:|
      self.create!(user: user, book: book, action: action.split("_").join("."))
    end
  end
end
