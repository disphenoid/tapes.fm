class Tapesfm.Views.TapeSetting extends Backbone.View
  template: JST['tapes/settings']
  events:
    "click .new_tape_btn" : "new_tapedeck"
    "click .update_tape_btn" : "new_tapedeck"
    "click .delete_tape_btn" : "delete_tapedeck"
    "click .project_field" : "showProjects"
    "click .project_field_label" : "showProjects"
    "click .project_btn" : "selectProject"
    "click .genre_field" : "showGenres"
    "click .genre_field_label" : "showGenres"
    "click .genre_btn" : "selectGenre"
    #"submit .tape_cover_form" : "submitTape"
    "change .setting_cover_input" : "submitTape"


  selectGenre: (e) ->
    $(@el).find(".settings_main").animate({left: "0px"}, 300, "easeOutExpo")
    $(@el).find(".settings_genre").animate({left: "300px"},300, "easeOutExpo")

    $(@el).find(".genre_field").val($(e.currentTarget).data("genre_name")).focus().blur()

    console.log $(e.currentTarget).data("genre_name")
    @model.set({genre: $(e.currentTarget).data("genre_name")}, {silent: true})

  selectProject: (e) ->
    $(@el).find(".settings_main").animate({left: "0px"}, 300, "easeOutExpo")
    $(@el).find(".settings_project").animate({left: "300px"},300, "easeOutExpo")

    console.log $(e.currentTarget).data("project_name")
    console.log $(e.currentTarget).data("project_id")


    unless $(e.currentTarget).data("project_name") == "none"
      @model.set({project_id: $(e.currentTarget).data("project_id")}, {silent: true})
      $(@el).find(".project_field").val($(e.currentTarget).data("project_name")).focus().blur()

    else
      @model.set({project_id: null}, {silent: true})
      $(@el).find(".project_field").val("").focus().blur()





  showGenres: (e) ->
    $(@el).find(".settings_main").animate({left: "-300px"}, 300, "easeOutExpo")
    $(@el).find(".settings_genre").animate({left: "0px"},300, "easeOutExpo")
    console.log "dsa"


  showProjects: (e) ->
    $(@el).find(".settings_main").animate({left: "-300px"}, 300, "easeOutExpo")
    $(@el).find(".settings_project").animate({left: "0px"},300, "easeOutExpo")

    console.log "dsa"

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
          

        @model.set({cover_s: e.cover.s.url, cover_m: e.cover.m.url, cover: e.cover.m.url, id: e._id})


        #$(@el).find(".cover_pic").replace("ddsad")#attr("src", ("http://"+e.cover.url))
        $(@el).find(".cover_pic").attr('src', ("http://"+e.cover.url))
        $(@el).find(".cover_pic").show(500)
        $(@el).find(".cover_label").addClass("active")
        $(@el).find(".cover_pic").removeClass("inactive")

        console.log "http://"+e.cover.m.url
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


    _.each Tapesfm.user.projects, (project) =>
      # _.each project.users, (user) =>
      #   $(_el).find(".settings_project subline").append(user.name)


      $(@el).find(".settings_project").append(" <div class=\"project_btn\" data-project_id=\"#{project.id}\" data-project_name=\"#{project.name}\"> <div class=\"headline\"> #{project.name} </div> <div class=\"subline\">  </div> </div>

")



    this

