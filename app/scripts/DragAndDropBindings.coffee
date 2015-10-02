define [], ()->
  class DragAndDropBindings
    constructor: ()->
      @dragAreas = []
      @handlers = []

    registerArea: (dropArea)->
      dropArea.assignedTo = @
      @dragAreas.push dropArea

    registerHandler: (handler)->
      handler.assignedTo = @
      @handlers.push handler

    _parseCoords: (el)-> el.element.getBBox()

    _range : (val, min, max) -> val >= min and val <= max



    _requestDropZone: ( handler )->
      _el = @_parseCoords handler
      for port in @dragAreas
        _port = @_parseCoords port
        if @_range(_el.cx, _port.x, _port.x + _port.w ) and @_range(_el.cy, _port.y, _port.y + _port.h )
          console.log "DROP ZONE IS HERE :)"
          console.log "connected", handler, " to ", port
          break
        else 
          console.log "DROP ZONE IS NOT HERE :("

    bindComponents: ->
      @handlers.forEach (handler)=>
        handler.onHandlerStop = ()=>
          @_requestDropZone handler
