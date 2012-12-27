class InviteMailer < ActionMailer::Base
  include Resque::Mailer

  default :from => '"tapes.fm" <j@tapes.fm>'
  
  def invite(invite_id)   
    #@mission = Mission.current_mission
    @invite = Invite.find(invite_id)

    if @invite

      unless @invite.user
        email_subject = "You got an Invite for tapes.fm" 
      else
        email_subject = "#{@invite.user.name} invited you to join tapes.fm" 
      end

      mail(:to => @invite.email, :subject => email_subject ) 

    end
    
  end



end



