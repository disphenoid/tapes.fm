class Tapesfm.Views.DashboardActivity extends Backbone.View
  template: JST['dashboard/comment']

  initialize: ->


  templateType: (model) ->

    switch model.get("type")
      when "comment" then JST['dashboard/comment']
      when "follow" then JST['dashboard/follow']
      when "tape" then JST['dashboard/newtape']
      when "version" then JST['dashboard/version']

      #else go work




  render: ->
   @template = @templateType(@model)

   rendertContent = @template(activity: @model)
   $(@el).html(rendertContent)
   $(@el).find(".date").timeago()
   this



