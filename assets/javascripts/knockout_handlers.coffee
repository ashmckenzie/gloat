ko.bindingHandlers['fadeOut'] =
  update: (element) ->
    $(element).css(opacity: 1)
    clearTimeout(@timer) if @timer

    @timer = _.delay =>
      $(element).animate({ opacity: 0 })
    , 3000
