define ['Snap', 'DropZone', 'Handler', 'Path'], (Snap, DropZone, Handler, Path)->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ()->
      new Handler @paper.group(@paper.circle(0, 0, 50), @paper.circle(0, 0, 50))
