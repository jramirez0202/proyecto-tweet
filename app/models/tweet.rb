class Tweet < ApplicationRecord
    belongs_to :user
    belongs_to :tweet, optional: true
    has_many :likes
    validates :content, presence: true
    paginates_per 5


    
end
