Gloat.SlideStatusView = Backbone.View.extend

  timer: null

  initialize: ->
    @model.on 'change', @render, @
    @render()

  show: ->
    @$el.show().css(opacity: 1)

    clearTimeout(@timer) if @timer

    @timer = _.delay =>
      @$el.animate({ opacity: 0 })
    , 3000

  setupHover: ->
    @$el.mouseover =>
      @show()

  render: ->
    template = _.template($("#slide-status-template").html(), @model.toJSON())
    @$el.html(template)
