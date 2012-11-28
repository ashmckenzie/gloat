#= require vendor/jquery
#= require vendor/underscore
#= require vendor/backbone
#= require vendor/mousetrap
#= require namespace
#= require_tree ./gloat

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
}

jQuery ->

  $('#slides .slide').first().show()

  slideManager = new Gloat.SlideManager($('#slides .slide'))
  slideStateView = new Gloat.SlideStateView(el: $('footer'), model: slideManager)

  Mousetrap.bind '?', ->
    alert('show help!')

  Mousetrap.bind 'left', ->
    slideManager.previousSlide()

  Mousetrap.bind [ 'right', 'space' ], ->
    slideManager.nextSlide()
