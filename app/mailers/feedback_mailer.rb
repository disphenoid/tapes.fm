class FeedbackMailer < ActionMailer::Base
  include Resque::Mailer

  default :from => '"tapes.fm" <j@tapes.fm>'
  
  def feedback(feedback_id)   
    #@mission = Mission.current_mission
    @feedback = Feedback.find(feedback_id)

    if @feedback

      email_subject = "tapes.fm Feedback from #{@feedback.user.name}" 

      mail(:from => @feedback.user.email, :to => "feedback@tapes.fm", :subject => email_subject ) 

    end
    
  end



end




