class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @friend = @user.followers.find_by(follower: current_user)
    end

    def destroy
    end
    
end
