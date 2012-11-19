class FollowsController < ApplicationController

  def create

    if current_user
      @target = User.find(params[:target_id]);


      if current_user.id.to_s != params[:target_id]

        if current_user.follow! @target

          current_user.push_activity "follow", @target


        end
      end

        respond_to do |format| 
          
          format.js 
          #format.html {flash[:notice] = "You successfully follow this user"; redirect_to(:back)}

        end

    end
  end

  def destroy
    
    #@target = User.find(params["follow"][:target_id]);
    @target = User.find(params[:id]); 

    if current_user.unfollow! @target

    end

      respond_to do |format|
        format.js 
        #format.html { flash[:notice] = "You successfully stopped following this user"; redirect_to(:back) }
      end

    # destroy! do |success, failure|
    #   success.html { flash[:notice] = "You successfully stopped following this user"; redirect_to profile_url(resource.target.profile.uid) }
    #   failure.html { flash[:error] = "Could not stop following this user", redirect_to(:back) }
    # end
  end

  protected

    def begin_of_association_chain
      current_user
    end



end
