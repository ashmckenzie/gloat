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

      @processSlides Gloat.bootstrap.slides

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
    @slideListVisible(value)
    @scrollToSlideListCurrent() if value

  scrollToSlideListCurrent: ->
    currentIndex = @currentSlide().number() - 1

    if (currentIndex >= 0)
      amount = (206 * currentIndex) - (206 * 2)
      $('#slide-list').scrollLeft(amount)