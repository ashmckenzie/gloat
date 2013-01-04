window.Gloat.SlideViewModel = class SlideViewModel

  constructor: (@slide) ->
    @number = ko.observable(@slide.number)
    @preShowSlide = ko.observable(@isPreShowSlide())
    @cssClasses = ko.observable(@slide.options.classes)
    @html = ko.observable(@slide.html)

  theme: ->
    @slide.options?.theme ? true

  isPreShowSlide: ->
    if @slide.preShow == true
      'true'
    else
      'false'
