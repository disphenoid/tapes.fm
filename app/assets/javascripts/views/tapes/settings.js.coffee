class Tapesfm.Views.TapeSetting extends Backbone.View
  template: JST['tapes/settings']
  events:
    "click .headline" : "infield"
    "click .new_tape_btn" : "new_tapedeck"
    "click .update_tape_btn" : "new_tapedeck"

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
        {name:  $("#tape_name_field_#{settingId}").val()}
        {success: (model, response)->
          console.log response.id
          #window.location = "/tapedeck/"+response._id
          $(".popin-overlay").removeClass("active")

          $(".setting-popin").removeClass("active")

          $(".popin-overlay").die "click"
        })


  infield: (e) ->
    alert "dd"
    #$(e.currentTarger).html("dd")
    # $(@el).find("label").inFieldLabels()

  initialize: ->
   
   # $(".new_tape_btn").live "click", -> 

   #   remixable = ($("#tape_remixable").attr('checked') == "checked")

   #   #new_tapdeck = new Tapesfm.Models.Tapedeck()


   #   @model.set({name: $("#tape_name_field").val(), remixable: remixable, commentable: $("#tape_commentable").val(), public: $("#tape_public").val() })
   #   @model.save(
   #    {name:  $("#tape_name_field").val()}
   #    {success: (model, response)->
   #      console.log response.id
   #      window.location = "/tapedeck/"+response._id
   #    })
        


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

    this

