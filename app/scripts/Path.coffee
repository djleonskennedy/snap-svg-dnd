define [], ()->
  class Path
    constructor: (@element, @className)->
      @element.addClass(@className)

    draw:(attributes, element)->
      @element.attr d: attributes
      @