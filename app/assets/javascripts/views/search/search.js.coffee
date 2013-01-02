class Tapesfm.Views.Search extends Backbone.View
  template: JST['search/search']
  


  openResults: (e) ->
    # alert "dd"
    $("#search_results").slideDown("fast","easeOutCirc" )

  closeResults: (e) ->
    # alert "dd"
    $("#search_results").slideUp("fast","easeInOutCirc")
  
  addTapes: (tape) ->
    
    # $("#search_results").append(tape.get("name"))
    tapeView = new Tapesfm.Views.SearchTape(model: tape)
    $('#search_results').append(tapeView.render().el)

  initialize: ->
    # rendertContent = @template(model: @model)
    # $(@el).html(rendertContent)
    #
    #
    $("#search_label").inFieldLabels()
    $("#search_results").hide()
    $("#search_field").focus (e) =>
      @openResults()
    $("#search_field").blur (e) =>
      @closeResults()

    $('#search_field').typing
      start: (event, $elem) =>
      stop: (event, $elem) =>
        $("#search_button").addClass("searching")
        $.ajax({ url: "/api/search?q=#{$($elem).val()}" }).done (data) =>

          console.log data

          $("#search_results").html("")
          @collection = new Tapesfm.Collections.Tapes(data.tapes)
          @collection.each @addTapes
          $("#search_button").removeClass("searching")
          

      delay: 400

    this





