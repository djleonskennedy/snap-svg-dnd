define ['Snap', 'DropArea', 'Handler', 'Path'], ( Snap, DropArea, Handler, Path )->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ->
      new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 100, 600
      new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 300, 600
      new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 500, 600
      new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw 700, 600


      new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw 100, 50
      new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw 200, 50
      new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw 300, 50
