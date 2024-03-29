window.Gloat.DeckKeyBindings = class DeckKeyBindings

  slideChanged: false

  constructor: (@deckViewModel) ->
    window.self = @

    Mousetrap.bind '?', ->
      $('#help').reveal();

    Mousetrap.bind 'escape', ->
      @deckViewModel.toggleSlideList(false)

    Mousetrap.bind 'd', ->
      location.href = @deckViewModel.decksIndexPath

    Mousetrap.bind 'l', ->
      @deckViewModel.toggleSlideList()

    Mousetrap.bind 'g s', ->
      location.hash = @deckViewModel.firstSlideNumber()

    Mousetrap.bind 'g e', ->
      location.hash = @deckViewModel.totalSlideNumber()

    Mousetrap.bind 'left', ->
      if !@deckViewModel.slideListVisible()
        @deckViewModel.gotoPreviousSlide()
      else
        @deckViewModel.gotoPreviousSlideList()

    Mousetrap.bind [ 'right', 'space' ], ->
      if !@deckViewModel.slideListVisible()
        @deckViewModel.gotoNextSlide()
      else
        @deckViewModel.gotoNextSlideList()

    Mousetrap.bind 'enter', ->
      if @deckViewModel.slideListVisible()
        @deckViewModel.slideListClick(@deckViewModel.currentSlideList())

    Mousetrap.stopCallback = =>
      @slideChanged == true

    for number in [ 1..deckViewModel.totalSlideNumber() ]
      do (number) ->
        numberAsString = (number).toString().split('').join(' ')
        Mousetrap.bind(numberAsString + ' enter', ->
          location.hash = parseInt(number)
          self.slideChanged = true
          _.delay =>
            self.slideChanged = false
          , 100
        , 'keydown')
