class ApiController < ActionController::API 

  
  def news
    @tweet = Tweet.last(50)
    #para hacer consulta de un rango de fechas este condicional una forma de hacerlo
    # if params[:startDate].present? && params[:endDate].present?
    #   startDate = params[:startDate]
    #   endDate = params[:endDate]
    #   @tweet = Tweet.where('created_at BETWEEN ? AND ? ', startDate, endDate)
    # end
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


def dates_ranges
  startDate = params[:startDate]
  endDate = params[:endDate]
  @tweet = Tweet.where('created_at BETWEEN ? AND ? ', startDate, endDate)
  date_hash = @tweet.map do |i|
    i.tweets_info
  end

  render json: date_hash
end


  def create_tweets_api

        user_email = params[:email]
        authenticate = User.find_by(email: user_email)
        # if authenticate == true
        #   @tweet = Tweet.new(tweet_params)
        #   @tweet = current_user.tweets.new(tweet_params)
        # end
        render json: user_email
  end
  
  def tweet_params
    params.require(:tweet).permit(:content,:user_id, :tweet_id)
  end
end
