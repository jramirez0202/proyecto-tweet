class Like < ApplicationRecord
    belongs_to :user
    belongs_to :tweet


    def like
        tweet.update(global_likes: tweet.global_likes += 1)
    end
    
    def dislike
        tweet.update(global_likes: tweet.global_likes -= 1)
    end
end
