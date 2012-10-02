class CollaboratorsController < ApplicationController
  respond_to :json

  def show

    @collaborators = Tapedeck.find(params[:id]).collaborators

  end


end
