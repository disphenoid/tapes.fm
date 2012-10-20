jQuery.fn.trunacat = (p_max_size = 15, p_over = true) ->

  max_size = p_max_size

  trunc = (p_obj) ->
    string = p_obj.data("full_text")
    string = string.substring(0, max_size)
    string = string + "…"
    p_obj.text(string)



  if $(this).data("full_text").length >= max_size
    
    trunc $(this)

    if p_over
      $(this).mouseenter ->
        $(this).html($(this).data("full_text"))
        
      $(this).mouseleave ->
        #$(this).html($(this).data(string))
        trunc $(this)





