class CollaboratorsController < ApplicationController
  respond_to :json

  def show

    @collaborators = Tapedeck.find(params[:id]).all_collaborators

  end


end
