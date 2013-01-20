class Tapesfm.Views.TapeSetting extends Backbone.View
  template: JST['tapes/settings']
  events:
    "click .new_tape_btn" : "new_tapedeck"
    "click .update_tape_btn" : "new_tapedeck"
    "click .delete_tape_btn" : "delete_tapedeck"
    "change .setting_cover_input" : "submitTape"

    "click .checkable" : "checkLicense"

  checkLicense: (e) ->

    if $(e.currentTarget).hasClass("active")
      $(e.currentTarget).removeClass("active")
    else
      $(e.currentTarget).addClass("active")


  submitTape: (e) ->
    e.preventDefault()
    console.log $(@el).find(".tape_cover_form").first()

    $(@el).find(".tape_cover_form").ajaxSubmit
      success: (e) =>
        console.log e

        # if @model.isNew()
        #   console.log "dd"
        #   tapedeck = new Tapesfm.Models.Tapedeck(response)
        #   tapedeck.set({id: response._id})
          

        @model.set({cover_s: e.cover_s, cover_m: e.cover_m, cover: e.cover_m, id: e._id})


        #$(@el).find(".cover_pic").replace("ddsad")#attr("src", ("http://"+e.cover.url))
        $(@el).find(".cover_pic").attr('src', ("http://"+e.cover))
        $(@el).find(".cover_pic").show(500)
        $(@el).find(".cover_label").addClass("active")
        $(@el).find(".cover_pic").removeClass("inactive")

        # console.log "http://"+e.ccover_m
        #$(@el).find(".cover_pic").hide()
        
        #@render()
  delete_tapedeck: (e) ->
    agree = confirm("Delete this Tape?")
    if agree
      Tapesfm.tapes.remove(@model)
      @model.destroy()
      $(".popin-overlay").removeClass("active")
      $(".setting-popin").removeClass("active")
      $(".popin-overlay").die "click"

  new_tapedeck: (e) ->
    
    #console.log $("#tags_#{@model.get("id")}").tagit("assignedTags")
    if @model.isNew()
      settingId = "new"
    else
      settingId = @model.get("id")



    name = $("#tape_name_field_#{settingId}").val()
    remixable =   ($("#tape_remixable_#{settingId}").attr('checked') == "checked")
    commentable = ($("#tape_commentable_#{settingId}").attr('checked') == "checked")
    private_tape = ($("#tape_private_#{settingId}").attr('checked') == "checked")
    tags = ($("#tags_#{@model.get("id")}").tagit("assignedTags"))

    #creative common
    cc_by = $("#license_by_#{@model.get("id")}").hasClass("active")
    cc_sa = $("#license_sa_#{@model.get("id")}").hasClass("active")
    cc_nd = $("#license_nd_#{@model.get("id")}").hasClass("active")
    cc_nc = $("#license_nc_#{@model.get("id")}").hasClass("active")


    @model.set({name: name, remixable: remixable, commentable: commentable, private: private_tape, tags: tags, cc_by: cc_by, cc_sa: cc_sa, cc_nd: cc_nd, cc_nc: cc_nc })
    @model.save(
      {}
      {success: (model, response) ->
        #console.log "response " + response.id
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


  addProjects: (project) ->
    alert "ddd"
  checkPublicSwitch: (e) ->
    # alert @model.id
    if ($("#tape_private_#{@model.id}").attr('checked') == "checked")
      $(@el).find(".license_box").removeClass("inactive")
    else
      $(@el).find(".license_box").addClass("inactive")
      # $(@el).find(".license.sa").removeClass("active")

  render: ->

    if @model.isNew()
     settingId = "new"
    else
     settingId = @model.get("id")

    rendertContent = @template(model: @model,  settingId: settingId )
    
    $(@el).html(rendertContent)

      
    $(@el).find("#setting-popin_#{@model.id} label").inFieldLabels()

    $(@el).find("#switch_private_#{@model.id}").click (e) =>
      console.log "change private"

    $(@el).find("#switch_private_#{@model.id}").click (e) =>
      console.log "change remix"
      @checkPublicSwitch e

    this

