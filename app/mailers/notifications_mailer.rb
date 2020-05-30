class NotificationsMailer < ApplicationMailer
  def notify_book_read(book, read_by)
    @book = book
    @read_by = read_by

    mail(to: @book.user.email, subject: "Hoera! #{@read_by.name} heeft een boek van je gelezen.")
  end

  def notify_book_downloaded(book, downloaded_by)
    @book = book
    @downloaded_by = downloaded_by

    mail(to: @book.user.email, subject: "Hoera! #{@downloaded_by.name} heeft een boek van je gedownload.")
  end

  def notify_book_uploaded(book, recipients)
    @book = book

    mail(bcc: recipients.map(&:email), subject: "Hoera! #{@book.user.name} heeft zonet een nieuw boek toegevoegd aan onze bibliotheek.")
  end
end
