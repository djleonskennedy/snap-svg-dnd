define [], ->
  class Handler
    constructor: (@element)->
      @_initialCoordsString = null
      @assignedTo = null

      #apply classes for handler
      @element[1].addClass('handler-area')
      @element[0].addClass('handler-visible')

      #apply drag functionality
      @element.drag @_move, @_start, @_stop

      #if handler position needs to be reset set it to 'true'
      @returnToStart = off

      #init transform
      @draw 0, 0

      #events
      @onHandlerStart = null
      @onHandlerStop = null
      @onHandlerMove = null

    draw:(x, y)->
      @element.transform "t #{x}, #{y}"
      @

    snapTo : (el)=>
      @element.transform "t #{el.pivot.px} #{el.pivot.py}"
      @

    _start: (x, y) =>
      # using transform for thouchy screens devices
      if typeof x == 'object' and x.type == 'touchstart'
        x.preventDefault()
        @element.data 'ox', x.changedTouches[0].clientX
        @element.data 'oy', x.changedTouches[0].clientY
      @element.data 'origTransform', @element.transform().local

      #call event '@onHandlerStart'
      do @onHandlerStart if @onHandlerStart?

      #save coords for "return to start" functionality
      @initialCoordsString =
        x: @element.getBBox().x
        y: @element.getBBox().y

    _stop:()=>
      @draw @_initialCoordsString if @returnToStart

      #call event '@onHandlerStop'
      do @onHandlerStop if @onHandlerStop?

    _move: (dx, dy) =>
      # using transform for thouchy screens devices

      if typeof dx == 'object' and dx.type == 'touchmove'
        changedTouches = dx.changedTouches[0]
        dx = changedTouches.clientX - @element.data('ox')
        dy = changedTouches.clientY - @element.data('oy')
      @element.transform @element.data('origTransform') + "#{(if @element.data('origTransform') then 'T' else 't')} #{dx} #{dy}"

      #call event '@onHandlerMove'
      do @onHandlerMove if @onHandlerMove?