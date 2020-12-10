class Book < ApplicationRecord
  has_one_attached :book
  has_many_attached :images
  paginates_per 20

  validates :book, attached: true, content_type: { in: 'application/epub+zip', message: "moet een epub formaat zijn" }

  belongs_to :user
  has_and_belongs_to_many :read_by_users, join_table: :users_read_books, class_name: "User", foreign_key: :user_id, association_foreign_key: :book_id
  has_many :user_actions

  after_create :parse_epub!, if: -> { epub? }
  before_update :complete_with_goodreads!, if: :title_changed?

  class << self
    def search(query, options)
      results = where("title LIKE :query OR author LIKE :query", query: "%#{query}%")
      results = results.left_outer_joins(:read_by_users).where("users_read_books.book_id IS NULL") if options.try(:dig, :hide_read)
      results
    end
  end

  def cover
    images.find(cover_id) if cover_id
  end

  def epub?
    book.content_type.match?(/epub/)
  end

  def parse_epub!
    transaction do
      self.images.destroy_all
      Tempfile.open("#{id}.epub", Dir.tmpdir) do |file|
        file.binmode
        book.blob.download { |chunk| file.write(chunk) }
        file.rewind
        epub_book = EPUB::Parser.parse(file)

        self.update(
          title: epub_book.title,
          isbn: epub_book.metadata.unique_identifier.to_s,
          author: epub_book.metadata.creators.join(", ")
        )

        epub_book.manifest.items.select {|item| item.media_type =~ /image/ }.each do |item|
          cover_file = File.open("#{Rails.root}/tmp/#{item.href.to_s.parameterize}", "wb") { |f| f.write(item.read); f }
          self.images.attach(io: File.open(cover_file.path), filename: item.href.to_s, content_type: item.media_type)
        end

        update(cover_id: images.first.id) if images.any?

        file.close
        file.unlink
      end
    rescue EPUB::OCF::PhysicalContainer::NoEntry
      # figure out what to do
    end

    complete_with_goodreads! if isbn.present? || title.present?
    save!
  end

  def complete_with_goodreads!
    return true # TODO: find a workaround now that Goodread has disabled their API

    goodreads_book = Goodreads::Client.new.book_by_title(title)

    self.introduction = goodreads_book.description.to_s.gsub(/\u2028/, '')
    self.goodreads_rating = goodreads_book.average_rating
    self.goodreads_url = goodreads_book.url
    self.pages = goodreads_book.num_pages
    self.isbn = goodreads_book.isbn13
  rescue Goodreads::NotFound
    return true # Ignore when book not found
  end
end
