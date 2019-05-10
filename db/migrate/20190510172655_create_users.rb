class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.boolean :can_invite_users, default: false, null: false

      t.timestamps
    end
  end
end
