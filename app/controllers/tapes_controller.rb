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
    if current_user
      @tape = Tape.new
      
      @tape.user_id = current_user.id
      @tape.name = params[:name]
      @tape.tapedeck_id = params[:tapedeck_id]
      @tape.track_ids = params[:track_ids]
      unless params[:bpm].blank?
        @tape.bpm = params[:bpm].to_f
      else
        @tape.bpm = 120
      end

      @tape.tapedeck.active_tape_id = @tape.id

      #@tape.track_setting_ids = params[:track_setting_ids]


      new_settings = params[:track_settings]

    if current_user && (@tape.tapedeck.collaborator? current_user)

      # puts "################ #{new_settings.count} #{new_settings}"
      new_settings.each do |setting|
        puts "######################## #{setting}"
        @tape.track_setting_init(setting[:track_id])
        @tape.track_setting_pan(setting[:track_id],setting[:pan])
        @tape.track_setting_mute(setting[:track_id],setting[:mute])
        @tape.track_setting_solo(setting[:track_id],setting[:solo])
        @tape.track_setting_volume(setting[:track_id],setting[:volume])

      end

      if @tape.save && @tape.tapedeck.save

        if @tape.tapedeck.tapes.count == 1
          current_user.push_activity "tape", @tape
        else
          current_user.push_activity "version", @tape
        end

      end

    end

    #render :json => @tape
    end
  end
  
  def update
    if current_user
      @tape = Tape.find(params[:id])
      if current_user && (@tape.tapedeck.collaborator? current_user)
        if @tape.user.id == current_user.id
          @tape.update_attributes!(params[:tape])


        new_settings = params[:track_settings]
        new_settings.each do |setting|

          @tape.track_setting_volume(setting[:track_id],setting[:volume])
          @tape.track_setting_pan(setting[:track_id],setting[:pan])
          @tape.track_setting_mute(setting[:track_id],setting[:mute])
          @tape.track_setting_solo(setting[:track_id],setting[:solo])

        end

        # end
        end
        render :json => @tape
      end
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
