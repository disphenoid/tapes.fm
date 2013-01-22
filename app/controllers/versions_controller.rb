class VersionsController < ApplicationController
  respond_to :json

  def show

    @versions = Tapedeck.find(params[:id]).tapes.desc(:created_at)

  end


end
