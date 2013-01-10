class Tapesfm.Views.TapedeckHeader extends Backbone.View
  template: JST['tapedecks/header']
  
  initialize: ->
    
    #@model.on('change:name', @render, this)
    #@collection.on('reset', @render, this)
    #@render()
    
    #@collection.on('changed:name', @render, this)
    #@collection.on('add', @render, this)

  addTags: (tags) ->
    if tags
      for tag in tags
        do (tag) =>
           @addTag tag
  addTag: (tag) ->
    $(@el).find("#tags_#{@model.get("id")}").tagit("createTag", String(tag))


  saveTags: (tags) ->
    @model.set({tags: tags}, {silent: true})
    @model.save(
      {}
      { silent: true
      })
    


  render: ->
    rendertContent = @template(tapedeck: @model)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    #
    
    if Tapesfm.user && Tapesfm.user.collaborator
      readOnly = false
      placeholderText = "Click to add a tag"
    else
      readOnly = true
      placeholderText = ""


    $(@el).find("#tags_#{@model.get("id")}").tagit
      placeholderText: placeholderText
      readOnly: readOnly
      autocomplete: {source: "/api/tags",delay: 0, minLength: 1}

        
    @addTags @model.get("tags")
    $(@el).find("#tags_#{@model.get("id")}").tagit

       afterTagAdded: (e,ui) =>
        @saveTags tags = ($(@el).find("#tags_#{@model.get("id")}").tagit("assignedTags"))
        console.log "save add"
      afterTagRemoved: (e,ui) =>
        @saveTags tags = ($(@el).find("#tags_#{@model.get("id")}").tagit("assignedTags"))
        console.log "save remove"

    
    $(@el).find('ul.tagit input').alpha({nocaps:true, allow: "1234567890"})
    


    this

