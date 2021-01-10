class CreatesTagsTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tags_tweets, id: false do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :tweet, index: true, foreign_key: true
    end
  end
end
