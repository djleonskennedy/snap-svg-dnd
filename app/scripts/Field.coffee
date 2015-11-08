define ['Snap', 'DropArea', 'Handler', 'DragAndDropBindings', 'Path'], (Snap, DropArea, Handler, DragAndDropBindings, Path)->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ->
      circle = (r)=> @paper.circle(0, 0, r)

#      matrix = new Snap.matrix()
#      matrix.rotate()
#      startX = 200
#      startY = 200
#      i = 0
#      radius = 100
#      while i < Math.PI *2
#        i += 0.01
#        @paper.circle(Math.cos(i)*radius + startX, Math.sin(i)*radius + startY, 2)

      binding01 = new DragAndDropBindings()

      port01 = new DropArea(circle(60), circle(5)).draw(100, 600)
      port02 = new DropArea(circle(60), circle(5)).draw(300, 600)

      path01 = do @paper.path
      path02 = do @paper.path

      handler01 = new Handler(@paper.group(circle(10), circle(50)), 'handler-area-01', 'handler-visible-01').draw(100, 50)
      handler02 = new Handler(@paper.group(circle(10), circle(50)), 'handler-area-01', 'handler-visible-01').draw(200, 50)

      new Path(path01, handler01, handler02, "path", @paper)

      binding01.registerArea port01
      binding01.registerArea port02

      binding01.registerHandler handler01
      binding01.registerHandler handler02

      binding01.bindComponents()
