class CreateFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :friends do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.integer :friend_id, index: true, foreign_key: true

      t.timestamps
    end
    add_foreign_key :friends, :users, column: :user_id
    add_foreign_key :friends, :users, column: :friend_id
    end
end

