Gloat.SlideStatusView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @
    @render()

  show: ->
    @$el.show().css(opacity: 1)
    _.delay =>
      @$el.animate({ opacity: 0 })
    , 3000

  setupHover: ->
    @$el.mouseover =>
      @show()

  render: ->
    template = _.template($("#slide-status-template").html(), @model.toJSON())
    @$el.html(template)
