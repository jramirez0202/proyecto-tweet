class TweetsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only:[:index, :show]
  before_action :set_tweet, only: [:show, :edit, :update, :destroy, :create]
  # load_and_authorize_resource
  # GET /tweets
  # GET /tweets.json


  def index 
    
    @tweet = Tweet.new
    if params[:q].present?
      search = params[:q]
      @tweets = Tweet.where('content LIKE ?', "%#{search}%")
    else
      @tweets = Tweet.page params[:page]
      @tweets = Tweet.includes(:tweet, :user, :retweets).order("updated_at DESC").page
    end
  end

  def user_tweets
    if user_signed_in?
      @retweet = Tweet.find(params[:tweet_id])
    end
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
    @tweet_id = params[:tweet_id]
    @retweet = Tweet.find(params[:tweet_id])
    redirect_to root_path
  end
  

  def like
    @tweet = Tweet.all.find(params[:id])
    Like.create(user_id: current_user.id, tweet_id: @tweet.id)
    redirect_to tweet_path(@tweet)
  end

  def retweet
    @tweet = set_tweet
    @retweet = @tweet.retweets.new(user: current_user)
    @retweet.save
    rt = Tweet.new(content: @tweet.content, user: current_user)
    rt.content += " Retweet to @#{@tweet.user.name}"
    rt.save
    redirect_to root_path
  end

  def hashtags
    tag = Tag.find_by(name: params[:name])
    @tweets = tag.tweets.page
  end

  # GET /tweets/1/edit
  def edit
  end



  def apiCreate
    user = User.authenticate(params[:email], params[:password])
    @tweet= Tweet.new
    @tweet = Tweet.new(request.body.read)
    @tweet = current_user.tweets.new(request.body.read)

    respond_to do |format|
      if @tweet.save
        format.json { render json: {status:"tweet create"}}
      else
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end



  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    # @tweet = current_user.tweets.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end
  # Metodos follow y unfollow
  
  def follow
    user = User.find(params[:id])
    follows = Friend.new(user: user, friend: current_user)
    follows.save
    redirect_to root_path
  end

  def destroy_following
    user = User.find(params[:id])
    friend = current_user.users_i_follow(user)
    friend.destroy
    redirect_to root_path
  end
  
  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id]) if params[:id]
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content,:user_id, :tweet_id)
    end
end
