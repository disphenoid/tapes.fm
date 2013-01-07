class Tapesfm.Views.DashboardActivity extends Backbone.View
  template: JST['dashboard/comment']
  tagName: "li"
  className: "stream_item"

  initialize: ->


  templateType: (model) ->

    switch model.get("type")
      when "comment" then JST['dashboard/comment']
      when "follow" then JST['dashboard/follow']
      when "tape" then JST['dashboard/newtape']
      when "version" then JST['dashboard/version']
      when "remix" then JST['dashboard/newremix']

      #else go work

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
   @template = @templateType(@model)

   rendertContent = @template(activity: @model)
   $(@el).html(rendertContent)
   $(@el).addClass(@getIndex())
   $(@el).find(".date").timeago_short()
   this



