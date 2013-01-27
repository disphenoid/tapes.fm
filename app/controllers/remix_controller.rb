class RemixController < ApplicationController
  def index
    tapedeck = Tapedeck.find(params[:tapedeck_id])
    if tapedeck
      @remixes = tapedeck.remixes.asc(:created_at)
    end
      
  end

  def create
    if current_user
      original_td = Tapedeck.find(params[:tapedeck_id])
      original_tape = Tape.find(params[:tape_id])

      if original_td && original_tape
        @remix_td = Tapedeck.new

        
        #set original

        if original_td.original
          @remix_td.original = original_td.original
        else
          @remix_td.original = original_td
        end 

        #set cover
        
        @remix_td.cover_id = original_td.cover_id 

        #set meta
        
        @remix_td.remix = true 
        @remix_td.name = original_td.name
        @remix_td.original_name = original_td.name
        @remix_td.original_author = original_td.user.name
        @remix_td.original_user_id = original_td.user_id
        @remix_td.tags = original_td.tags
        
        #set permissions
        
        @remix_td.commentable = true
        @remix_td.public = true
        
        #set user
        
        @remix_td.user = current_user
        @remix_td.collaborator_ids.push current_user.id

        #set rights
        
        @remix_td.cc = original_td.cc
        @remix_td.cc_by = original_td.cc_by
        @remix_td.cc_sa = original_td.cc_sa
        @remix_td.cc_nc = original_td.cc_nc
        @remix_td.cc_nd = original_td.cc_nd

        if original_td.cc_sa
           @remix_td.cc_lock = true 
        end 

        # copy tape

        @remix_td.active_tape_id = copy_tape(original_tape)
        
        if @remix_td.save

          current_user.push_activity "remix", @remix_td
        
        end


      end

    end

  end

  private

  def copy_tape original_tape

    tape = Tape.new
    tape.name = original_tape.name
    tape.bpm = original_tape.bpm
    tape.user = original_tape.user
    tape.tapedeck_id = @remix_td.id
    tape.created_at = original_tape.created_at

    tape.track_ids = copy_tracks(original_tape)

    if tape.save()

      return tape.id
    end


  end
 
  def copy_tracks(original_tape)

    new_track_ids = []

    original_tape.track_ids.each do |track_id|
      
      if original_track = Track.find(track_id)
        
        track = Track.new
        track.name = original_track.name
        track.user = current_user #original_track.user
        track.copy = true #original_track.user
        track.duration = original_track.duration
        track.group = track.id
        track.color = original_track.color
        track.audio_id = original_track.audio_id
        


        # track.audio_id = original_track.audio_id
        if track.save()
          new_track_ids.push(track.id)
        end

      end

    end

    new_track_ids      

  end




end
