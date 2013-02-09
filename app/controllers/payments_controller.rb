class PaymentsController < ApplicationController

  def paypal_success

    if params[:st] == "Completed"

      payment = Payment.find(params[:payment])
      payment.complete = true 
      payment.paypal_tx = params[:tx] 
      
      if upgrade_account(payment.plan_id, payment.days)
        if payment.save
          flash[:note] = "You got an Upgrade!"
          redirect_to "/thanks"
        else    
          flash[:note] = "Something wrong?"
          redirect_to "/support" 
        end
      end

    end

  end

  def paypal_error

    if params[:payment]

      payment = Payment.find(params[:payment])
      payment.error = true
      payment.params = params

      if payment.save



      end

    end

    flash[:error] = "Sorry something went wrong... " 
    redirect_to "/upgrade"

  end


  def payment_url

    if ENV["APP_DOMAIN_HOST"] 
      host = ENV["APP_DOMAIN_HOST"]
    else
      host = "localhost:5000"
    end

    if current_user

      payment = Payment.new
      payment.user = current_user
      payment.country = params[:country]

      case params[:upgrade]

        when "test"

          upgrade = params[:upgrade]
          payment.plan_id = 1
          if payment.country == "eu"
            paypal_id = "GVNTMKLPK8RHS"
          else
            paypal_id = "DH5TQTQXLE65Y"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"

        when "2"
          
          upgrade = params[:upgrade]
          payment.plan_id = 2
          payment.days = 365

          if payment.country == "eu"
            paypal_id = "JXMK4H42ZZAYG"
          else
            paypal_id = "2MHF7JVH5UK96"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"

        when "3"

          upgrade = params[:upgrade]
          payment.plan_id = 3
          payment.days = 365

          if payment.country == "eu"
            paypal_id = "C8HEYC4425X7N"
          else
            paypal_id = "AAJUDB3PJUPBJ"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"

        when "4"

          upgrade = params[:upgrade]
          payment.plan_id = 4
          payment.days = 365

          if payment.country == "eu"
            paypal_id = "MP3TLEMF6ACKJ"
          else
            paypal_id = "KNF3LA34FYFS4"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"

        when "5"

          upgrade = params[:upgrade]
          payment.plan_id = 2
          payment.days = 31

          if payment.country == "eu"
            paypal_id = "VWQWDWNV9KQ2J"
          else
            paypal_id = "8U546697EHBJ6"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"

        when "6"

          upgrade = params[:upgrade]
          payment.plan_id = 3
          payment.days = 31

          if payment.country == "eu"
            paypal_id = "VHUH6EZWTZVFS"
          else
            paypal_id = "NJKRXBMHBYQMN"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"

        when "7"

          upgrade = params[:upgrade]
          payment.plan_id = 4
          payment.days = 31

          if payment.country == "eu"
            paypal_id = "WZTBJ4G9V2U9S"
          else
            paypal_id = "JB6PPF8XZF2RY"
          end

          url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=#{paypal_id}&return=http://#{host}/paypal/success?payment=#{payment.id}&upgrade=#{upgrade}"




        else
          flash[:note] = "Sorry Please try again... "
          url = "/upgrade" 
      end


    if payment.save
      redirect_to url
    else
      flash[:error] = "Sorry Please try again... " 
      redirect_to "/upgrade"
    end
    else
      redirect_to "/"
    end
    
  end


  def thanks

    unless current_user
      redirect_to "/"
    end

    
  end
  
  private

  def upgrade_account(upgrade, days)
    
    current_user.plan_id = upgrade
    current_user.plan_expire = (Date.today) + days.days
    current_user.save

  end

end
