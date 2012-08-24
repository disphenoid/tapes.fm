class VersionsController < ApplicationController
  respond_to :json

  def show

    @versions = Tapedeck.find(params[:id]).tapes

  end
end
