ActiveAdmin.register Tweet do

  permit_params :content, :user_id, :global_likes
  scope :all
  filter :created_at, as: :date_range

  form do |f|
    inputs 'Add new tweet' do
    f.input :user_id,
    label: 'Email',
    as: :select,
    collection: User.pluck(:email, :id)
    input :content
    end
    actions
    end
    

  

  index do
    column :user_id
    column :name do |tweet|
    tweet.user.name
    end
    column :content
    column :retweets do |tweet|
    tweet.retweets.count
    end
    column :likes do |tweet|
    tweet.likes.count
    end
    column :folowers_id do |tweet|
    tweet.user.followers.count  
    end
    column :folowings_id do |tweet|
      tweet.user.following.count
      end
    actions
  end

  

    
  # index do
  #   (Tweet.column_names - ["retweet"]).each do |c|
  #     column c.to_sym
  #   end
  #   column :retweet do 
  #     Retweet.count
  #   end
  # end




  
    # form do |f|
    #   inputs "Details" do
    #     input :user
    #     input :content
    #   end
    # end

  # or
  #
  # permit_params do
  #   permitted = [:content, :user_id, :global_likes,]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
