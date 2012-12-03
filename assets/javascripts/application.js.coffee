#= require vendor/jquery
#= require vendor/jquery.reveal
#= require vendor/underscore
#= require vendor/sammy
#= require vendor/knockout
#= require vendor/mousetrap
#= require vendor/rainbow/rainbow
#= require_tree ./vendor/rainbow
#= require namespace
#= require knockout_handlers
#= require_tree ./gloat

_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
}

jQuery ->

  window.slideManagerViewModel = new Gloat.SlideManagerViewModel()

  new Gloat.SlideManagerRouting(window.slideManagerViewModel)
  new Gloat.SlideManagerKeyBindings(window.slideManagerViewModel)
  ko.applyBindings(window.slideManagerViewModel)
