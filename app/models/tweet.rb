class Tweet < ApplicationRecord
    belongs_to :user
    belongs_to :tweet, optional: true
    has_many :likes
    has_many :retweets
    validates :content, presence: true
    paginates_per 50


end
