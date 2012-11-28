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
  slideStateView = new Gloat.SlideStateView(el: $('footer'), model: slideManager)

  Mousetrap.bind '?', ->
    alert('show help!')

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

  slideManager.showSlide(parseInt(startWithSlideNumber))
