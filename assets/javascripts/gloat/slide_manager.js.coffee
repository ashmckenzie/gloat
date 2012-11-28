Gloat.SlideManager = Backbone.Model.extend

  defaults:
    slides: []
    currentSlideIndex: 0

  initialize: (@selector) ->
    @selector.each (i, slide) =>
      @get('slides').push slide

  toJSON: ->
    {
      currentSlideNumber: @currentSlideNumber(),
      totalSlideNumber: @totalSlideNumber(),
      slides: @get('slides')
    }

  totalSlideNumber: ->
    @get('slides').length

  currentSlideNumber: ->
    @get('currentSlideIndex') + 1

  currentSlide: ->
    $(@get('slides')[@get('currentSlideIndex')])

  showSlide: (slideNumber) ->
    $(@get('slides')).each (i, slide) =>
      $(slide).hide()

    @set('currentSlideIndex', (slideNumber - 1))
    @currentSlide().show()
    window.location.hash = slideNumber

  nextSlide: ->
    if @get('currentSlideIndex') < (@totalSlideNumber() - 1)
      slideIndex = @get('currentSlideIndex') + 1
      @showSlide(slideIndex + 1)

  previousSlide: ->
    if @get('currentSlideIndex') > 0
      slideIndex = @get('currentSlideIndex') - 1
      @showSlide(slideIndex + 1)
