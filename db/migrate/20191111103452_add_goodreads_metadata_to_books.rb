class AddGoodreadsMetadataToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :goodreads_rating, :string
    add_column :books, :goodreads_url, :string
    add_column :books, :pages, :integer
  end
end
