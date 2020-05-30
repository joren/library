require 'test_helper'

class BookNotificationActionTest < ActiveSupport::TestCase
  # Trigger uploaded
  test "book owner does not receive when uploaded book" do
    user = User.create!(name: "foo", email: "foo@bar.be")
    book = Book.new(user_id: user.id)

    sent_email = BookNotificationAction.new(book).trigger_uploaded
    assert_not_includes sent_email.bcc, user.email
    assert_includes sent_email.bcc, users(:one).email
  end

  test "Exclude uploaded book when user disabled setting" do
    user = users(:one).tap { |u| u.update!(notify_book_uploaded: false) }
    book = Book.new(user: users(:three))

    sent_email = BookNotificationAction.new(book).trigger_uploaded
    assert_not_includes sent_email.bcc, user.email
    assert_includes sent_email.bcc, users(:two).email
  end

  # Trigger read
  test "Sends 'read' mail when setting enabled" do
    user = users(:three).tap { |u| u.update!(notify_book_read: true) }
    book = Book.new(user: users(:three))

    sent_email = BookNotificationAction.new(book).trigger_read(users(:one))
    assert_includes sent_email.to, user.email
  end

  test "Doesn't send 'read' mail when setting disabled" do
    user = users(:three).tap { |u| u.update!(notify_book_read: false) }
    book = Book.new(user: users(:three))

    assert_nil BookNotificationAction.new(book).trigger_read(users(:one))
  end

  test "Doesn't send 'read' mail when read own book" do
    user = users(:three).tap { |u| u.update!(notify_book_read: false) }
    book = Book.new(user: users(:three))

    assert_nil BookNotificationAction.new(book).trigger_read(user)
  end

  # Trigger downloaded
  test "Sends 'downloaded' mail when setting enabled" do
    user = users(:three).tap { |u| u.update!(notify_book_downloaded: true) }
    book = Book.new(user: users(:three))

    sent_email = BookNotificationAction.new(book).trigger_downloaded(users(:one))
    assert_includes sent_email.to, user.email
  end

  test "Doesn't send 'downloaded' mail when setting disabled" do
    user = users(:three).tap { |u| u.update!(notify_book_downloaded: false) }
    book = Book.new(user: users(:three))

    assert_nil BookNotificationAction.new(book).trigger_downloaded(users(:one))
  end

  test "Doesn't send 'downloaded' mail when read own book" do
    user = users(:three).tap { |u| u.update!(notify_book_downloaded: false) }
    book = Book.new(user: users(:three))

    assert_nil BookNotificationAction.new(book).trigger_downloaded(user)
  end
end
