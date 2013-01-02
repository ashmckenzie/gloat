#= require vendor
#= require namespace
#= require knockout_handlers
#= require_tree ./gloat

_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
}

jQuery ->

  window.slideManagerViewModel = new Gloat.SlideManagerViewModel(
    Gloat.bootstrap.decksIndexPath,
    Gloat.bootstrap.deck
  )

  new Gloat.SlideManagerRouting(window.slideManagerViewModel)

  _.delay =>
    new Gloat.SlideManagerKeyBindings(window.slideManagerViewModel)
    ko.applyBindings(window.slideManagerViewModel)
  , 0
