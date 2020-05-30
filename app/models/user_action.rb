class UserAction < ApplicationRecord
  belongs_to :user
  belongs_to :book

  ACTIONS = %w(book_read book_downloaded book_uploaded).freeze

  class << self
    def book_read!(user:, book:)
      create!(user: user, book: book, action: "book.read")
    end

    def book_downloaded!(user:, book:)
      create!(user: user, book: book, action: "book.downloaded")
    end

    def book_uploaded!(user:, book:)
      create!(user: user, book: book, action: "book.uploaded")
    end
  end
end
