class Book < ApplicationRecord
  has_one_attached :book
  has_many_attached :images

  belongs_to :user

  after_create :parse_epub!, if: -> { epub? }

  def cover
    images.first
  end

  def epub?
    book.content_type.match?(/epub/)
  end

  def parse_epub!
    Tempfile.open("#{id}.epub", Dir.tmpdir) do |file|
      file.binmode
      book.blob.download { |chunk| file.write(chunk) }
      file.rewind
      epub_book = EPUB::Parser.parse(file)

      self.update(title: epub_book.title)

      epub_book.manifest.items.select {|item| item.media_type =~ /image/ }.each do |item|
        cover_file = File.open("#{Rails.root}/tmp/#{item.href.to_s.parameterize}", "wb") { |f| f.write(item.read); f }
        self.images.attach(io: File.open(cover_file.path), filename: item.href.to_s, content_type: item.media_type)
      end

      file.close
      file.unlink
    end
  end
end
