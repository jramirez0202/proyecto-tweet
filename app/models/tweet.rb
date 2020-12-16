class Tweet < ApplicationRecord

    validates :content, presence: true
    
    belongs_to :user
    has_many :likes

end
