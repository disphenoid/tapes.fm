class Tapesfm.Views.AdminRequest extends Backbone.View
  template: JST['admin/users/request']

  events:
    "click #invite_btn" : "inviteUser"

  initialize: ->
  
  inviteUser: (e) ->

    invite = new Tapesfm.Models.Invite()
    invite.set({value: @model.get("email")})
    invite.set({request_id: @model.get("id")})
    invite.save(
      {}
      {success: (model, response) =>
        #console.log "response " + response.id
        #window.location = "/tapedeck/"+response._id
        # invite = new Tapesfm.Models.Invite(response)
        # invite.set({id: response._id})
        console.log response

        # Tapesfm.tapes.unshift(tapedeck)
        if response._id
          # @collection.add(invite)
          #alert "invited " + @model.get("email")
          $(@el).fadeOut("slow")


      })
    
  

  
  render: ->
    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)

    this








