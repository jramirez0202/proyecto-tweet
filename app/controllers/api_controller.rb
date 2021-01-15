class ApiController < ActionController::API 
  
  def news
    @tweet = Tweet.all
    if params[:startDate].present? && params[:endDate].present?
      startDate = params[:startDate]
      endDate = params[:endDate]
      @tweet = Tweet.where('created_at BETWEEN ? AND ? ', startDate, endDate)
    end
    array = []
      @tweet.each do |tweet|
        retweets=[]
        tweet.retweets.each do |rt|
          retweets << rt.id
        end
      array << { id: tweet.id,
                content: tweet.content,
                user_id: tweet.user_id,
                like_count: tweet.likes.count,
                retweets_count: tweet.retweets.count,
                rewtitted_from: retweets
      }
    end 

    render json: array
  end

end
