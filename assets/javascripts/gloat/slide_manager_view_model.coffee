window.Gloat.SlideManagerViewModel = class SlideManagerViewModel

  constructor: ->
    window.self = @

    @slides = ko.observableArray()
    @currentSlide = ko.observable()
    @previousSlide = ko.observable()
    @slideListVisible = ko.observable(false)

    @totalSlideNumber = ko.computed =>
      @slides().length

    @percentComplete = ko.computed =>
      if @currentSlide()
        currentSlide = @currentSlide().number()
      else
        currentSlide = 1

      ((currentSlide / @totalSlideNumber()) * 100).toFixed()

    @_getSlides()

  gotoNextSlide: ->
    if @currentSlide().number() < @totalSlideNumber()
      location.hash = @currentSlide().number() + 1

  gotoPreviousSlide: ->
    if @currentSlide().number() > 1
      location.hash = @currentSlide().number() - 1

  loadSlide: (number) ->
    @previousSlide(@currentSlide())

    @currentSlide(@slides()[number - 1])

    if @slideListVisible()
      @scrollToSlideListCurrent()

  parseAnyCodeFragments: ->
    Rainbow.color()

  slideListClick: (slide) ->
    location.hash = slide.number()

  processSlides: (slides) =>
    _.each slides.slides, (slide) =>
      self.slides.push(new Gloat.SlideViewModel(slide))

  toggleSlideList: (force) ->
    value = force ? !@slideListVisible()
    @scrollToSlideListCurrent() if value
    @slideListVisible(value)

  scrollToSlideListCurrent: ->
    currentIndex = @currentSlide().number() - 1

    if (currentIndex >= 0)
      amount = (206 * currentIndex) - (206 * 2)
      _.delay =>
        $('#slide-list').scrollLeft(amount)
      , 0

  _getSlides: ->
    $.ajax async: false, type: 'GET', url: '/slides', success: @processSlides
