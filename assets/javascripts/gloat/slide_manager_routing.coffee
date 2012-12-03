window.Gloat.SlideManagerRouting = class SlideManagerRouting

  constructor: (@slideManagerViewModel) ->
    window.self = @

    Sammy(->
      @get "#:slideNumber", ->
        number = parseInt(@params.slideNumber)

        if number >= 1 && number <= self.slideManagerViewModel.totalSlideNumber()
          self.slideManagerViewModel.loadSlide(number)
        else
          location.hash = 1

      @get '', ->
        location.hash = 1

    ).run()
