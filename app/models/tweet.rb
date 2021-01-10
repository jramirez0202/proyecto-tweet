class Tweet < ApplicationRecord
    belongs_to :user
    belongs_to :tweet, optional: true 
    
    has_many :likes, dependent: :destroy
    has_many :retweets, dependent: :destroy
    has_many :hashtags

    has_and_belongs_to_many :tags, dependet: :destroy

    validates :content, presence: true
    paginates_per 50

    after_create do
        tweet = Tweet.find_by(id: self.id)
        hashtags = self.content.scan(/#\w+/)
        hashtags.uniq.map do |hashtag|
            tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
            tweet.tags << tag
        end
    end

    before_update do
        tweet = Tweet.find_by(id: self.id)
        hashtags = self.content.scan(/#\w+/)
        hashtags.uniq.map do |hashtag|
            tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
            tweet.tags << tag
        end
    end
end
