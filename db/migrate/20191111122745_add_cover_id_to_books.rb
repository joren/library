class AddCoverIdToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :cover_id, :integer
  end
end
