define ['Snap', 'DropZone', 'Handler', 'Path'], (Snap, DropZone, Handler, Path)->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ->
      new DropZone(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 100, 600
      new DropZone(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 300, 600
      new DropZone(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 500, 600
      new DropZone(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 700, 600


      new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw 100, 50
      new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw 200, 50
      new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw 300, 50
