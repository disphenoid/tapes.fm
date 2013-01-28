//= require .//tapedeck_app
//= require_tree ../templates/
//= require_tree .//models
//= require_tree .//collections
//= require_tree .//views
//= require .//routers/tapedecks
//= require_tree .//lib
//= require .//search_app
//= require .//tracks_app
//= require .//routers/search
//= require .//routers/tracks
//
//
$(function(){

  window.onbeforeunload = function(e) {
      if(window.existing_tape) {
        return 'Please save your changes, or leave anyway?';
      }  else {
        return null;
      }

  };

});
