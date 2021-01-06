class Tweet < ApplicationRecord
    belongs_to :user
    belongs_to :tweet, optional: true 
    
    has_many :likes, dependent: :destroy
    has_many :retweets, dependent: :destroy
    validates :content, presence: true
    paginates_per 50


end
