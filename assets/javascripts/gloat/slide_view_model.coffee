window.Gloat.SlideViewModel = class SlideViewModel

  constructor: (@slide) ->
    @number = ko.observable(@slide.number)
    @cssClasses = ko.observable(@slide.options.classes)
    @html = ko.observable(@slide.html)
