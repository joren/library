class BookNotificationAction
  def initialize(book)
    @book = book
  end

  def trigger_read(ready_by)
    UserAction.book_read!(user: ready_by, book: @book)
    return if ready_by == @book.user
    return unless @book.user.notify_book_read
    NotificationsMailer.notify_book_read(@book, ready_by).deliver_now
  end

  def trigger_downloaded(downloaded_by)
    UserAction.book_downloaded!(user: downloaded_by, book: @book)
    return if downloaded_by == @book.user
    return unless @book.user.notify_book_downloaded
    NotificationsMailer.notify_book_downloaded(@book, downloaded_by).deliver_now
  end

  def trigger_uploaded
    UserAction.book_uploaded!(user: @book.user, book: @book)
    recipients = User.where(notify_book_uploaded: true).where.not(id: @book.user_id)
    return if recipients.none?
    NotificationsMailer.notify_book_uploaded(@book, recipients).deliver_now
  end
end
