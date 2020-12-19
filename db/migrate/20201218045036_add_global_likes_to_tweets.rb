class AddGlobalLikesToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :global_likes, :integer, default: 0
  end
end
