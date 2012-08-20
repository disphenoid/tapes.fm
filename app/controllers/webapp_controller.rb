class WebappController < ApplicationController
  layout :resolve_layout

  def index
  end
  def tapedeck 
    @json = Tapedeck.find(params[:id]).to_json(:include => "tape", :include => {"tape" => {:include => "tracks"}}) 

  end
  def login
  end

  def uploadtest
    @track = Track.new
  end
  def upload
    #handle upload
    track = Track.new
    track.asset = params[:track][:asset]
    track.save
    redirect_to "/"

    #track.asset = params[]
  end


  def resolve_layout
    case action_name
    when "login"
      "application"
    else
      "application"
    end
  end

end
