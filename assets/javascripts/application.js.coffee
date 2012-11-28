#= require jquery
#= require mousetrap

class Slide
  constructor: (@id) ->

  hide: ->
    alert('Would hide' + @id)

class SlideManager

  currentSlideIndex = 0
  slides = []

  constructor: (@selector) ->
    @selector.each (i, slide) ->
      slides.push slide

  currentSlide: ->
    $(slides[currentSlideIndex])

  previousSlide: ->
    @currentSlide().hide()
    @_previousSlide().show()

  nextSlide: ->
    @currentSlide().hide()
    @_nextSlide().show()

  _nextSlide: ->
    currentSlideIndex += 1 if currentSlideIndex < (slides.length - 1)
    @currentSlide()

  _previousSlide: ->
    currentSlideIndex -= 1 if currentSlideIndex > 0
    @currentSlide()

jQuery ->

  # Show the first slide
  #
  $('#slides .slide').first().show()

  # Bind left + right to move slides
  #
  slideManager = new SlideManager $('#slides .slide')

  Mousetrap.bind '?', ->
    alert('show help!')

  Mousetrap.bind 'left', ->
    slideManager.previousSlide()

  Mousetrap.bind [ 'right', 'space' ], ->
    slideManager.nextSlide()
