class ApiController < ActionController::API 
  def news
    @tweet = Tweet.all
    array = []
    all = { tweet:   
      @tweet.sort.each do |tweet|
      array << { id: tweet.id,
                content: tweet.content,
                user_id: tweet.user_id,
                like_count: tweet.likes.count,
                retweets_count: tweet.retweets.count,
                rewtitted_from: tweet.user.id
      }
    end }

    render json: array
  end
end
