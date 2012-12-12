window.Gloat.SlideManagerKeyBindings = class SlideManagerKeyBindings

  slideChanged: false

  constructor: (@slideManagerViewModel) ->
    window.self = @

    Mousetrap.bind '?', ->
      $('#help').reveal();

    Mousetrap.bind 'escape', ->
      @slideManagerViewModel.toggleSlideList(false)

    Mousetrap.bind 'd', ->
      location.href = '/'

    Mousetrap.bind 'l', ->
      @slideManagerViewModel.toggleSlideList()

    Mousetrap.bind 'g s', ->
      location.hash = 1

    Mousetrap.bind 'g e', ->
      location.hash = @slideManagerViewModel.totalSlideNumber()

    Mousetrap.bind 'left', ->
      @slideManagerViewModel.gotoPreviousSlide()

    Mousetrap.bind [ 'right', 'space' ], ->
      @slideManagerViewModel.gotoNextSlide()

    Mousetrap.stopCallback = =>
      @slideChanged == true

    for number in [ 1..slideManagerViewModel.totalSlideNumber() ]
      do (number) ->
        numberAsString = (number).toString().split('').join(' ')
        Mousetrap.bind(numberAsString + ' enter', ->
          location.hash = parseInt(number)
          self.slideChanged = true
          _.delay =>
            self.slideChanged = false
          , 100
        , 'keydown')
