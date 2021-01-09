ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  
  #
  permit_params :email, :name, :password

  filter :email, as: :select
  filter :name


  form do |f|
      inputs 'Add new user' do
      input :email
      input :name
      input :password
      actions
    end
  end
    
  controller do
  def update
    if (params[:user][:password].blank? && params[:user]
        [:password_confirmation].blank?)
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
    end
        super
    end
  end
    

  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :photo_url, :password]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
