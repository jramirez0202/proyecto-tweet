class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :tweets
  has_many :likes
  has_many :retweets
  
  has_many :followers, class_name: 'Friend', foreign_key: 'user_id'
  has_many :following, class_name: 'Friend', foreign_key: 'friend_id'

  # validates :follower_id, presence: true
  # validates :followed_id, presence: true

  def user_following_me(user)
    self.followers.find_by(friend_id: user.id)
  end
      
  def users_i_follow(user)
    self.following.find_by(user_id: user.id)
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
