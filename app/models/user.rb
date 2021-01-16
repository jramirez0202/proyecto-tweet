class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :jwt_authenticatable, jwt_revocation_strategy: self

  
  
  has_many :tweets
  has_many :likes
  has_many :retweets
  
  has_many :followers, class_name: 'Friend', foreign_key: 'user_id'
  has_many :following, class_name: 'Friend', foreign_key: 'friend_id'

  def user_following_me(user)
    self.followers.find_by(friend_id: user.id)
  end
      
  def users_i_follow(user)
    self.following.find_by(user_id: user.id)
  end
end
