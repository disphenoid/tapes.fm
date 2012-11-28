class Tapesfm.Views.DashboardTape extends Backbone.View
  template: JST['dashboard/tape']

  initialize: ->
  tagName: "li"
  className: "dashboard_tape"

  getIndex: ->
    index = @model.collection.indexOf(@model)
    index + 1
    
    switch index
      when 0 then "one"
      when 1 then "two"
      when 2 then "three"
      when 3 then "four"
      else ""
  render: ->
   rendertContent = @template(tape: @model)
   $(@el).html(rendertContent)

   $(@el).addClass(@getIndex())
   $(@el).find(".date").timeago()
   this

