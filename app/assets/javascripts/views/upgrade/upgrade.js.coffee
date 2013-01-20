class Tapesfm.Views.Upgrade extends Backbone.View
  template: JST['upgrade/upgrade']

  initialize: -> 



  render: ->
   # @template = @templateType(@model)

   rendertContent = @template(activity: @model)
   $(@el).html(rendertContent)
   # $(@el).addClass(@getIndex())
   # $(@el).find(".date").timeago_short()
   this




