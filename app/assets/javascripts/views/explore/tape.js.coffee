class Tapesfm.Views.ExploreTape extends Backbone.View
  template: JST['explore/tape']
  events: ->
    "click .mini_tag" : "searchTag"
    
  initialize: ->
  tagName: "li"
  className: "explore_tape"
  
  searchTag: (e) ->
    tag = $(e.currentTarget).data("tag")
    $("#search_field").val("#{$("#search_field").val()} #{tag} ").keydown().keyup()
    e = $.Event('keypress')
    e.which = 65
    $('#search_field').trigger(e).blur().focus()


  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
    
    switch index
      when 0 then "one"
      when 1 then "two"
      when 2 then "three"
      when 3 then "four"
      when 4 then "five"
      when 5 then "six"
      when 6 then "seven"
      when 7 then "eight"
      when 8 then "nine"
      else ""

  render: ->
    rendertContent = @template(model: @model, index: @getIndex() )
    $(@el).html(rendertContent)
    $(@el).addClass(@getIndex())
    $(@el).find(".date").timeago()
    this




