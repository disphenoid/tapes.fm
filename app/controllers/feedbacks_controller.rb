class FeedbacksController < ApplicationController
  
  def create
       
    if current_user
      feedback = Feedback.new 
      feedback.user = current_user
      feedback.body = params[:body]
      if feedback.save
        FeedbackMailer.feedback(feedback.id).deliver
      end
    end


  end


end
