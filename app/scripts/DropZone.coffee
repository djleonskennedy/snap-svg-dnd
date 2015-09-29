define [], ->
  class DropZone
    constructor: (@element)->

      @connected = null

      @element.addClass('ports')

      #pivot point for snap hanlder to this DropZone
      @pivot = null

      #helper for checking wether DropZone is available
      @free = true

    draw:(coords)->
      @pivot =
        px: coords.x
        py: coords.y

      @element.transform "t #{coords.x}, #{coords.y}"
      @

    moveTo: (coords)->
      @element.transform "t #{coords.x} #{coords.y}"
      @

    setPivotPoint: (coords)->
      @pivot.px = coords.x
      @pivot.py = coords.y
      @