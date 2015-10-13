define ['Snap', 'DropArea', 'Handler', 'DragAndDropBindings', 'Path'], (Snap, DropArea, Handler, DragAndDropBindings, Path)->
  class Field
    constructor: (@height, @width)->
      @paper = Snap @height, @width

      do @initialization

    initialization: ->
      binding01 = new DragAndDropBindings()

      port01 = new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(100, 600)
      port02 = new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(300, 600)
      port03 = new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(500, 600)
      port04 = new DropArea(@paper.circle(0, 0, 60), @paper.circle(0, 0, 5)).draw(700, 600)

      handler01 = new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50)), 'handler-area-01', 'handler-visible-01').draw(100, 50)
      handler02 = new Handler(@paper.group(@paper.circle(0, 0, 10), @paper.circle(0, 0, 50)), 'handler-area-01', 'handler-visible-01').draw(200, 50)

      path01 = do @paper.path
      path02 = do @paper.path

      handler03 = new Handler(@paper.group(@paper.circle(0, 0, 18), @paper.circle(0, 0, 24)), 'handler-area-02', 'handler-visible-02').draw(600, 50)
      handler04 = new Handler(@paper.group(@paper.circle(0, 0, 18), @paper.circle(0, 0, 24)), 'handler-area-02', 'handler-visible-02').draw(900, 50)

      new Path(path01, handler01, handler02, "path")
      new Path(path02, handler03, handler04, "path2")

      binding01.registerArea port01
      binding01.registerArea port02
      binding01.registerArea port03
      binding01.registerArea port04

      binding01.registerHandler handler01
      binding01.registerHandler handler02
      binding01.registerHandler handler03
      binding01.registerHandler handler04

      binding01.bindComponents()

      binding01.onAllConnected = ()-> console.log "connected 01"
