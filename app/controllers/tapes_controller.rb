class TapesController < ApplicationController
  respond_to :json

  def index
    respond_with Tape.all
  end

  def show
    respond_with Tape.find(params[:id])
  end

  def create
    respond_with Tape.create(params[:tape])
  end
  
  def update
    respond_with Tape.update(params[:id], params[:tape])
  end

  def destroy
    respond_with Tape.destroy(params[:id])
  end

end
