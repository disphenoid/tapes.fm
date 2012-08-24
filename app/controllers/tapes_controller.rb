class TapesController < ApplicationController
  respond_to :json
  def index
    render :json => Tape.all
  end

  def show

    @tape = Tape.find(params[:id])
    #@json = render_to_string( template: 'tapes/tape.json.jbuilder', locals: { tape: @tape}) 
  end


  def create
    entry = Tape.create! params
    render :json => entry
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
