Gloat.SlideManager = Backbone.Model.extend

  defaults:
    slides: []
    slideStatusView: null
    currentSlideIndex: 0

  initialize: (@selector, @slideStatusView) ->
    @selector.each (i, slide) =>
      @get('slides').push slide

  toJSON: ->
    {
      currentSlideNumber: @currentSlideNumber(),
      totalSlideNumber: @totalSlideNumber(),
      percentageComplete: @percentageComplete(),
      slides: @get('slides')
    }

  totalSlideNumber: ->
    @get('slides').length

  currentSlideNumber: ->
    @get('currentSlideIndex') + 1

  percentageComplete: ->
    ((@currentSlideNumber() / @totalSlideNumber()) * 100).toFixed()

  currentSlide: ->
    $(@get('slides')[@get('currentSlideIndex')])

  currentSlideListSlide: ->
    $('#slide-list [data-slide-number="' + @currentSlideNumber() + '"]')

  showSlide: (slideNumber) ->
    @currentSlideListSlide().removeClass('current')
    @currentSlide().hide()

    @set('currentSlideIndex', (slideNumber - 1))
    top = (@currentSlide().parent().height() - @currentSlide().height()) / 2
    @currentSlide().css('top', top + 'px')
    @currentSlide().show()

    @get('slideStatusView').show()
    @currentSlideListSlide().addClass('current')
    @scrollToSlideListCurrent()

    window.location.hash = slideNumber

  scrollToSlideListCurrent: ->
    # @currentSlideListSlide()[0].scrollIntoView()

  nextSlide: ->
    if @get('currentSlideIndex') < (@totalSlideNumber() - 1)
      slideIndex = @get('currentSlideIndex') + 1
      @showSlide(slideIndex + 1)

  previousSlide: ->
    if @get('currentSlideIndex') > 0
      slideIndex = @get('currentSlideIndex') - 1
      @showSlide(slideIndex + 1)

  setupSlideListClickEvent: ->
    $('#slide-list section').on 'click', (event) =>
      @showSlide($(event.currentTarget).data('slide-number'))

