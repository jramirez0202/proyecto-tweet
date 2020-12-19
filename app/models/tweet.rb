class Tweet < ApplicationRecord
    belongs_to :user
    has_many :likes
    validates :content, presence: true
    paginates_per 2
    def liked?(user)
        !!self.likes.find{|like| like.user_id == user.id}        
    end

    
end
