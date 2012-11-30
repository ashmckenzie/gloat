#= require vendor/jquery
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

  slideManager = new Gloat.SlideManager($('#slides .slide'))
  slideStatusView = new Gloat.SlideStatusView(el: $('#slide-status'), model: slideManager)
  slideManager.set('slideStatusView', slideStatusView)

  Mousetrap.bind '?', ->
    alert('show help!')

  # FIX loading of double slides for slides > 9
  #
  for number in [ slideManager.totalSlideNumber()..1 ]
    do (number) ->
      numberAsString = (number).toString().split('').join(' ')
      Mousetrap.bind(numberAsString + ' enter', ->
        slideManager.showSlide(number)
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

  slideStatusView.setupHover()
