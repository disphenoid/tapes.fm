


jQuery ->
   $(".min_bar").data("used_time")
   $(".min_bar").data("total_time")

   value = window.tools.map($(".min_bar").data("used_time"), 0, $(".min_bar").data("total_time"), 0, 220)

   $(".min_bar").animate({width: value}, "slow")


   #$(".minutes_used").html(($(".minutes_used").data("used_time")  )+"min")



String.prototype.toHHMMSS =  ->
    sec_numb    = Math.floor(parseInt(this) / 1000)
    hours   = Math.floor(sec_numb / 3600)
    minutes = Math.floor((sec_numb - (hours * 3600)) / 60)
    seconds = sec_numb - (hours * 3600) - (minutes * 60)

    if (hours   < 10)
      hours   = "0"+hours
    if (minutes < 10)
      minutes = "0"+minutes
    if (seconds < 10)
      seconds = "0"+seconds
      time    = hours+':'+minutes+':'+seconds
    console.log(time)
    return time


window.tools =
  map: (p_value, old_min, old_max, new_min, new_max) ->
    #new_min + (new_max - new_min) * (p_value - old_min) / (old_max - old_min)
    val = (p_value - old_min) * (new_max - new_min) / (old_max - old_min) + new_min
  toMinutes: (v) ->
    d = Math.ceil(Number(v) / 1000)
    
    # s = Math.ceil(d % 3600 % 60)
    
    m = Math.ceil(d % 3600 / 60)
    # h = Math.floor(d / 3600)

    m

  toTime: (v) ->
    #mm = String(Math.floor(v)).substr(2)
    d = Math.floor(Number(v) / 1000)
    s = Math.floor(d % 3600 % 60)
    m = Math.floor(d % 3600 / 60)
    h = Math.floor(d / 3600)
    
    if m < 60
      minutes = "0" + m
    else
      minutes = m

    if s < 10
      seconds = "0" + s
    else
      seconds = s

    "#{minutes}:#{seconds}"
    #return ((h > 0 ? h + ":" : "") + (m > 0 ? (h > 0 && m < 10 ? "0" : "") + m + ":" : "0:") + (s < 10 ? "0" : "") + s)

    
