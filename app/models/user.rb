class User < ApplicationRecord
  has_many :tweets
  has_many :likes
  has_many :retweets
  
    has_many :followers, foreign_key: "followed_id", class_name: 'Friendship'
    has_many :following, foreign_key: "follower_id", class_name: 'Friendship'


    

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable


  def user_following_me(user)
    self.followers.find_by(follower_id: user.id)
  end
      
  def users_i_follow(user)
    self.following.find_by(followed: user.id)
  end
  # def follow(user)
  #   active_friendships.create(followed_id: user.id)
  # end  

  # def unfollow(user)
  #   active_friendships.find_by(followed_id: user.id).destroy    
  # end
    
  # def following?(user)
  #   following.include?(user)
  # end

  # def follower?(user)
  #   followers.include?(user)
    
  # end
end
