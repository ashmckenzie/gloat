Gloat.SlideStateView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @
    @render()

  render: ->
    template = _.template($("#footer-template").html(), @model.toJSON())
    @$el.html(template)
