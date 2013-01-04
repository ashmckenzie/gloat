#= require vendor
#= require namespace
#= require knockout_handlers
#= require_tree ./gloat

_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
}

jQuery ->

  window.deckViewModel = new Gloat.DeckViewModel(
    Gloat.bootstrap.decksIndexPath,
    Gloat.bootstrap.deck
  )

  new Gloat.DeckRouting(window.deckViewModel)

  _.delay =>
    new Gloat.DeckKeyBindings(window.deckViewModel)
    ko.applyBindings(window.deckViewModel)
  , 0
