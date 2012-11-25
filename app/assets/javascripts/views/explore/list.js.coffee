class Tapesfm.Views.ExploreList extends Backbone.View
  template: JST['explore/list']
  events: ->
    
  initialize: ->


  appendTapes: (tape) ->
    tapeView = new Tapesfm.Views.ExploreTape(model: tape)
    $(@el).find('#top_list').append(tapeView.render().el)



  render: ->
    rendertContent = @template(title: @options.title)
    $(@el).html(rendertContent)
    #$(@el).fadeIn(2000)
    @collection.each @appendTapes, this
    this




