ActiveAdmin.register Tweet do

  permit_params :content, :user_id, :global_likes
  scope :all
  scope :likes
  scope :retweets

  index do
    (Tweet.column_names - ["retweet"]).each do |c|
      column c.to_sym
    end
    column :retweet do 
      Retweet.count
    end
  end




  
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
