define ['Snap', 'DropArea', 'Handler', 'DragAndDropBindings', 'Path'], (Snap, DropArea, Handler, DragAndDropBindings, Path)->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ->
      binding01 = new DragAndDropBindings()
      binding02 = new DragAndDropBindings()

      binding01.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(100, 600)
      binding01.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(300, 600)
      binding02.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(500, 600)
      binding02.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(700, 600)

      binding01.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(100, 50)
      binding01.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(200, 50)
      binding02.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(300, 50)
      binding02.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(400, 50)

      binding01.bindComponents()
      binding02.bindComponents()
