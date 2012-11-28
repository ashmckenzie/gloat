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

  showSlide: (slideIndex) ->
    @currentSlide().hide()
    @set('currentSlideIndex', slideIndex)
    @currentSlide().show()

  nextSlide: ->
    if @get('currentSlideIndex') < (@totalSlideNumber() - 1)
      slideIndex = @get('currentSlideIndex') + 1
      @showSlide(slideIndex)

  previousSlide: ->
    if @get('currentSlideIndex') > 0
      slideIndex = @get('currentSlideIndex') - 1
      @showSlide(slideIndex)
