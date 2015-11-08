define [], ()->
  class DragAndDropBindings
    constructor: ()->

      @ports = []
      @handlers = []

      @locked = off

      #events
      @onAllConnected = null

    registerArea: (dropArea)->
      dropArea.assignedTo = @
      @ports.push dropArea

    registerHandler: (handler)->
      handler.assignedTo = @
      @handlers.push handler

    _parseCoords: (el)-> el.element.getBBox()

    _range : (val, min, max) -> val >= min and val <= max

    _requestDropZone: ( handler )->
      _el = @_parseCoords handler
      for port in @ports
        _port = @_parseCoords port
        if @_range(_el.cx, _port.x, _port.x + _port.w ) and @_range(_el.cy, _port.y, _port.y + _port.h)
          return port

    _connectionManager : ( handler, port )->
      unless port?
        @ports.forEach (_port)-> _port.handler = null if _port.handler is handler
      else
        unless port.handler?
          if handler.port?
            handler.port.handler = null if handler is handler.port.handler
          port.handler = handler
          handler.snapTo port
          handler.port = port
        else
          unless handler is port.handler
            handler.draw handler.lastPositionCoords.x, handler.lastPositionCoords.y
          else
            handler.snapTo port
      do @_checkConnections

    _checkConnections: ->
      if @ports.length > 0
        check = @ports.every (port)-> port.handler isnt null
        do @onAllConnected if check and @onAllConnected?

    bindComponents: ->
      @handlers.forEach (handler)=>
        handler.onHandlerStop = ()=>
          @_connectionManager handler, @_requestDropZone(handler)