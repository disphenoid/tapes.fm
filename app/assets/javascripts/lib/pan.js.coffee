class window.Pan
  canvas: null #document.getElementById("my_donut");
  position: 0
  ctx: null
  centerX: null
  centerY: null
  radius: 64
  value: 0
  rawValue: 0
  counterclockwise: false


  constructor: (canvas, value) ->
    @canvas = canvas
    #@canvas.width = "30px"
    #@canvas.height = "30px"
    @ctx = canvas.getContext("2d")
    @value = window.tools.map(value,-100,100,-1,1)

    
    # @canvas.height = 15
    # @canvas.style.height = "30px"

    # @canvas.width = 15
    # @canvas.style.width = "30px"

    @centerX = @canvas.width / 2
    @centerY = @canvas.height / 2

    @render()
  
   setValue: (value) ->
     @value = value
     @render()

   setRawValue: (value) ->
     @rawValue = value

   render: ->

     #start = 90  #* Math.PI / 180
    #end = ((360*0.5) +90) #* Math.PI / 180
    

    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)

    right = window.tools.map(@value,-1,1,0.5,2.5)
    if right < 1.51
      right = 1.51

    left = window.tools.map(@value,-1,1,0.5,2.5)
    if left > 1.49
      left = 1.49
    


    @ctx.beginPath()

    @ctx.arc(@centerX, @centerY, @radius, 0, 2 * Math.PI, @counterclockwise)
    #alert @ctx
    #
    #@ctx.arc(@centerX, @centerY, 5, 0 , 2 * Math.PI, false)

    @ctx.lineWidth = 16
    @ctx.strokeStyle = "rgba(0,0,0,0.4)"

    #@ctx.lineCap = "round"
    @ctx.stroke()

    @ctx.beginPath()

    @ctx.arc(@centerX, @centerY, 64, left* Math.PI, right * Math.PI, @counterclockwise)
    #alert @ctx
    #
    #@ctx.arc(@centerX, @centerY, 5, 0 , 2 * Math.PI, false)

    @ctx.lineWidth = 16
    @ctx.strokeStyle = "#FFF"

    @ctx.lineCap = "round"
    @ctx.stroke()

