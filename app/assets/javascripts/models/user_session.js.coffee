class Tapesfm.Models.UserSession extends Backbone.Model
  url: 'api/users/sign_in.json'
  paramRoot: 'user'

  defaults: 
    "email": ""
    "password": ""
  






