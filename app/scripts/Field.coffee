define ['Snap', 'DropArea', 'Handler', 'DragAndDropRoom', 'Path'], ( Snap, DropArea, Handler, DragAndDropRoom, Path )->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ->
      room01 = new DragAndDropRoom()
      room02 = new DragAndDropRoom()

      room01.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(100, 600)
      room01.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(300, 600)
      room01.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(100, 50)
      room01.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(200, 50)

      room02.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(500, 600)
      room02.registerArea new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(700, 600)
      room02.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(300, 50)
      room02.registerHandler new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50))).draw(400, 50)

      room01.launchRoom()
      room02.launchRoom()
