class LikesController < ApplicationController
    before_action :authenticate_user!
    
  def create
    @like = Like.find_by(user_id: current_user.id, tweet_id: params[:tweet_id])

    if @like && @like.button
      @like.update_attributes(button: false)
      @like.dislike
    elsif @like && !@like.button
      @like.update_attributes(button: true)
      @like.like
    else
      @like = Like.create(user_id: current_user.id, tweet_id: params[:tweet_id])
      @like.like
    end
    redirect_to root_path
  end
end