class UsersController < ApplicationController
  def user_name_unique
    unless params[:name].blank?
      unique = params[:name]
      user = User.find_by({name: /^#{params[:name]}$/i}) rescue nil
      unique = user.blank?
      render :text => unique
    end
  end

  def create
    @user = User.new
    invite = Invite.find_by({invite_hash: params[:hash]})
    @user.name = params[:name]
    @user.password = params[:password] 
    @user.email = invite.email
    if @user.save()
      sign_in(:user, @user)
      invite.invited_user = @user
      a = Autocomplete.new "user_names_complete"
      a.add @user.name
      
      
      if invite.save() 
        if invite.user
          invite.invited_user.follow! invite.user
          invite.user.follow! invite.invited_user 
        end
      end
    end
  end
end
