class Tapesfm.Views.TapeSetting extends Backbone.View
  template: JST['tapes/settings']
  events:
    "click .new_tape_btn" : "new_tapedeck"
    "click .update_tape_btn" : "new_tapedeck"
    #"submit .tape_cover_form" : "submitTape"
    "change .setting_cover_input" : "submitTape"


  submitTape: (e) ->
    console.log "dd"
    e.preventDefault()
    console.log $(@el).find(".tape_cover_form").first()

    $(@el).find(".tape_cover_form").ajaxSubmit
      success: (e) =>
        console.log e

        # if @model.isNew()
        #   console.log "dd"
        #   tapedeck = new Tapesfm.Models.Tapedeck(response)
        #   tapedeck.set({id: response._id})
          

        @model.set({cover: e.cover.url, id: e._id})

        #$(@el).find(".cover_pic").replace("ddsad")#attr("src", ("http://"+e.cover.url))
        $(@el).find(".cover_pic").attr('src', ("http://"+e.cover.url))
        $(@el).find(".cover_pic").show(500)
        $(@el).find(".cover_label").addClass("active")
        $(@el).find(".cover_pic").removeClass("inactive")

        console.log "http://"+e.cover.url
        #$(@el).find(".cover_pic").hide()
        
        #@render()

  new_tapedeck: (e) ->
    
    if @model.isNew()
      settingId = "new"
    else
      settingId = @model.get("id")


    if $("#tape_name_field_#{settingId}").val() != ""

      remixable =   ($("#tape_remixable_#{settingId}").attr('checked') == "checked")
      commentable = ($("#tape_commentable_#{settingId}").attr('checked') == "checked")
      public_tape = ($("#tape_public_#{settingId}").attr('checked') == "checked")



      @model.set({name: $("#tape_name_field_#{settingId}").val(), remixable: remixable, commentable: commentable, public: public_tape })
      @model.save(
        {}
        {success: (model, response) ->
          console.log "response " + response.id
          #window.location = "/tapedeck/"+response._id
          tapedeck = new Tapesfm.Models.Tapedeck(response)
          tapedeck.set({id: response._id})

          Tapesfm.tapes.unshift(tapedeck)

          $(".popin-overlay").removeClass("active")

          $(".setting-popin").removeClass("active")

          $(".popin-overlay").die "click"
        })




  initialize: ->
    #@model.on("change", @render, this)
   $(".settings input").live "focus", ->

  render: ->
    

    if @model.isNew()
     title = "New Tape"
    else
     title = "Edit Tape"

    if @model.isNew()
     settingId = "new"
    else
     settingId = @model.get("id")


    rendertContent = @template(model: @model, title: title, settingId: settingId )
    
    $(@el).html(rendertContent)

      
    $(@el).find("#setting-popin_#{@model.id} label").inFieldLabels()


    this

