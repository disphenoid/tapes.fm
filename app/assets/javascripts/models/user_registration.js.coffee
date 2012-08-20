class Tapesfm.Models.UserRegistration extends Backbone.Model
  url: 'api/users.json'
  paramRoot: 'user'

  defaults:
    "email": ""
    "password": ""
    "password_confirmation": ""
  
