class FriendshipsController < ApplicationController
  before_action :authenticate_user!

    def create
      other_user = User.find(params[:id])
      @friend = Friendship.new(follower_id: current_user.id, followed_id: other_user.id)
      @friend.save
      redirect_to root_path
    end

    def destroy
      @friend = Friendship.where(follower_id: params[:id])
      @friend.destroy
      redirect_to root_path
    end
    
  # def create
  #   current_user.follow(@user)
  #   redirect_to :back
  # end

  # def destroy
  #   current_user.unfollow(@user)
  #   redirect_to :back
  # end

  # private

  # def find_user
  #   @user = User.find(params[:user_id])
  # end
end
