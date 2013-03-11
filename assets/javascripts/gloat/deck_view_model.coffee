window.Gloat.DeckViewModel = class DeckViewModel

  constructor: (@decksIndexPath, @deck) ->
    window.self = @

    @slides = ko.observableArray()
    @currentTheme = ko.observable()
    @currentSlide = ko.observable()
    @currentSlideList = ko.observable()
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

    @processDeck @deck

  firstSlideNumber: ->
    @deck.firstSlideNumber

  gotoNextSlide: ->
    if @currentSlide().number() < @totalSlideNumber()
      location.hash = @currentSlide().number() + 1

  gotoNextSlideList: ->
    if @currentSlideList().number() < @totalSlideNumber()
      @currentSlideList(@slides()[@currentSlideListNumber()])
      @scrollToSlideListCurrent(@currentSlideList().number() - 1)

  gotoPreviousSlide: ->
    if @currentSlide().number() > 1
      location.hash = @currentSlide().number() - 1

  gotoPreviousSlideList: ->
    if @currentSlideList().number() > 1
      @currentSlideList(@slides()[@currentSlideListNumber() - 2])
      @scrollToSlideListCurrent(@currentSlideList().number() - 1)

  currentSlideListNumber: ->
    @currentSlideList().number()

  loadSlide: (number) ->
    @previousSlide(@currentSlide())

    currentSlide = @slides()[number - 1]
    @currentSlide(currentSlide)
    @currentSlideList(currentSlide)

    if @slideListVisible()
      @scrollToSlideListCurrent(@currentSlide().number() - 1)

  parseAnyCodeFragments: ->
    Rainbow.color()

  slideListClick: (slide) ->
    location.hash = slide.number()
    self.deckViewModel.toggleSlideList(false)

  processDeck: (deck) =>
    _.each deck.slides, (slide) =>
      self.slides.push(new Gloat.SlideViewModel(slide))

  toggleSlideList: (force) ->
    value = force ? !@slideListVisible()
    @slideListVisible(value)
    @scrollToSlideListCurrent(@currentSlide().number() - 1) if value

  scrollToSlideListCurrent: (index) ->
    if (index >= 0)
      amount = (206 * index) - (206 * 2)
      $('#slide-list').scrollLeft(amount)
