window.Gloat.DeckRouting = class DeckRouting

  constructor: (@deckViewModel) ->
    window.self = @

    Sammy(->
      @get "#:slideNumber", ->
        number = parseInt(@params.slideNumber)

        if number >= 1 && number <= self.deckViewModel.totalSlideNumber()
          self.deckViewModel.loadSlide(number)
        else
          location.hash = self.deckViewModel.firstSlideNumber()

      @get '', ->
        location.hash = self.deckViewModel.firstSlideNumber()

    ).run()
