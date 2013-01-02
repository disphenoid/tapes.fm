class Tapesfm.Views.SearchTape extends Backbone.View
  template: JST['search/tape']
  tag: "li"
  
  className: "search_tape"
  initialize: ->

  addTag: (e) ->
   console.log e
   

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
      else ""

  render: ->

    rendertContent = @template(model: @model)

    $(@el).html(rendertContent)
    $(@el).addClass(@getIndex())



    # @initPopIn(@model.get("id"))
    # $(@el).attr('id', @model.get("id"))

    this

