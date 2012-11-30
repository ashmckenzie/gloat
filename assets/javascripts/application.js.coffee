#= require vendor/jquery
#= require vendor/jquery.reveal
#= require vendor/underscore
#= require vendor/backbone
#= require vendor/mousetrap
#= require vendor/rainbow/rainbow
#= require_tree ./vendor/rainbow
#= require namespace
#= require_tree ./gloat

_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
}

jQuery ->

  slideChanged = false
  slideManager = new Gloat.SlideManager($('#slides .slide'))
  slideStatusView = new Gloat.SlideStatusView(el: $('#slide-status'), model: slideManager)
  slideManager.set('slideStatusView', slideStatusView)

  Mousetrap.bind '?', ->
    $('#help').reveal();

  Mousetrap.bind 'l', ->
    $('#slide-list').toggle()
    slideManager.setupSlideListHeights()
    slideManager.scrollToSlideListCurrent()

  Mousetrap.stopCallback = ->
    slideChanged == true

  for number in [ 1..slideManager.totalSlideNumber() ]
    do (number) ->
      numberAsString = (number).toString().split('').join(' ')
      Mousetrap.bind(numberAsString + ' enter', ->
        slideManager.showSlide(number)
        slideChanged = true
        _.delay =>
          slideChanged = false
        , 500
      , 'keydown')

  Mousetrap.bind 'left', ->
    slideManager.previousSlide()

  Mousetrap.bind [ 'right', 'space' ], ->
    slideManager.nextSlide()

  startWithSlideNumber = window.location.hash.replace(/#/, '')

  if !startWithSlideNumber ||
      !Gloat.Utils.isInt(startWithSlideNumber) ||
      startWithSlideNumber == '0' ||
      parseInt(startWithSlideNumber) > slideManager.totalSlideNumber()
    startWithSlideNumber = 1

  _.delay =>
    slideManager.showSlide(parseInt(startWithSlideNumber))
  , 1000

  slideManager.setupSlideListClickEvent()

  slideStatusView.setupHover()
