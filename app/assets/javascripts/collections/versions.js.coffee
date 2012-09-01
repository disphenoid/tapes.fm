class Tapesfm.Collections.Versions extends Backbone.Collection
  url: '/api/versions'
  model: Tapesfm.Models.Version
  comparator: (item) ->
    return -item.get("created_at")

