class window.CommentStrip
  constructor: ->
    # console.log "init "
  addComments: (comments) ->
    $("#tape_comments").html("dkfhkjsh")
    console.log "add comments"

  addComment: (comment) ->
    console.log "add one comment"

  clear: ->
    console.log "remove all comments"
  

jQuery ->
  window.Tapesfm.commentStrip = new window.CommentStrip()

