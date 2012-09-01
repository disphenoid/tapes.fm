class TapesController < ApplicationController
  respond_to :json
  def index
    #render :json => Tape.all
  end

  def show

    @tape = Tape.find(params[:id])
    #@json = render_to_string( template: 'tapes/tape.json.jbuilder', locals: { tape: @tape}) 
  end

  def create
    @tape = Tape.new
    
    @tape.name = params[:name]
    @tape.tapedeck_id = params[:tapedeck_id]
    @tape.track_ids = params[:track_ids]
    @tape.tapedeck.active_tape_id = @tape.id
    @tape.save
    @tape.tapedeck.save

    #render :json => @tape
  end
  
  def update
    tape = Tape.find(params[:id])
    tape.update_attributes!(params[:tape])
    render :json => tape
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Tape.destroy(params[:id])
  end

end
