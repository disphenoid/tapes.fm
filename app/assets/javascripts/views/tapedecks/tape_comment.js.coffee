class Tapesfm.Views.TapedeckTapeComment extends Backbone.View
  template: JST['tapedecks/tape_comment']
  events: ->
    "click .delete" : "removeCollaborator"
  initialize: ->

  removeCollaborator: (e) ->
    #alert $(e.currentTarget).data("id")

    #alert "delete" + $(e.currentTarget).data("id")
    id =  $(e.currentTarget).data("id")

    Tapesfm.tapedeck.tapedeck.get("comments").get($(e.currentTarget).data("id")).destroy()
    Tapesfm.tapedeck.tapedeck.get("comments").remove($(e.currentTarget).data("id"))
    #collaborator.destroy()
    # $(".comment##{id}").hide "slow", ->
    #  $(this).remove()

    #Tapesfm.tapedeck.tapedeck.save()
    

    


  render: ->
    

    
    #if $(".tape_comment").length > 0
      #alert "ddd"

    rendertContent = @template(model: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    #$(@el).find(".date").timeago()
    
    this




