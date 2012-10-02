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
      
      @tape.user_id = current_user.id
      @tape.name = params[:name]
      @tape.tapedeck_id = params[:tapedeck_id]
      @tape.track_ids = params[:track_ids]
      @tape.tapedeck.active_tape_id = @tape.id
    if current_user && (@tape.tapedeck.collaborator? current_user)
      @tape.save
      @tape.tapedeck.save

    end

    #render :json => @tape
  end
  
  def update
      tape = Tape.find(params[:id])
    if current_user && (tape.tapedeck.collaborator? current_user)
      if tape.user.id == current_user.id
        tape.update_attributes!(params[:tape])
      end
      render :json => tape
    end
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])

    if current_user
      if(tape = Tape.find(params[:id]))
        
        if tape.user.id == current_user.id && (tape.tapedeck.collaborator? current_user)
        @tapedeck = tape.tapedeck

        if tape.destroy
          @tapedeck.active_tape_id = @tapedeck.tapes.first.id
          @tapedeck.save
        end
        end
      end

      render :json => tape
    end
  end

end
