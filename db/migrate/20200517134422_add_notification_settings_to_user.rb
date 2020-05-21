class AddNotificationSettingsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notify_book_read, :boolean, default: true
    add_column :users, :notify_book_downloaded, :boolean, default: true
    add_column :users, :notify_book_uploaded, :boolean, default: true
  end
end
