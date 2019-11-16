class Book < ApplicationRecord
  has_one_attached :book
  has_many_attached :images
  paginates_per 20

  belongs_to :user

  after_create :parse_epub!, if: -> { epub? }

  class << self
    def search(query)
      where("title LIKE :query OR author LIKE :query", query: "%#{query}%")
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
  end

  def complete_with_goodreads!
    goodreads_book = Goodreads::Client.new.book_by_title(title)

    update!(
      introduction: goodreads_book.description.gsub(/\u2028/, ''),
      goodreads_rating: goodreads_book.average_rating,
      goodreads_url: goodreads_book.url,
      pages: goodreads_book.num_pages,
      isbn: goodreads_book.isbn13
    )
  rescue Goodreads::NotFound
    return true # Ignore when book not found
  end
end
