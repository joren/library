class CreateUploadedActions < ActiveRecord::Migration[5.2]
  def up
    Book.all.each do |book|
      UserAction.create!(
        user: book.user,
        book: book,
        action: "book_uploaded",
        created_at: book.created_at,
        updated_at: book.created_at
      )
    end
  end
end
