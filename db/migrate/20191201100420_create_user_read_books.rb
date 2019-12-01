class CreateUserReadBooks < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :books, table_name: :users_read_books
  end
end
