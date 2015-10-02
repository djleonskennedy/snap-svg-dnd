define ['Snap'], (Snap)->
  class DropArea

    messages =
      pivotErr : "DropArea module: ERROR ! 'pivotVisualizer' is not defined, please provide svg element to use this functionality"

    constructor: (@element, pivotVisualiser)->

      @assignedTo = null

      #if visualizes is provided it'll help to see where pivot point is
      @_pivotVisualizer = pivotVisualiser if pivotVisualiser?

      @element.addClass('drop-zone')

      #pivot point for snap hanlder to this DropArea
      @pivot = px: 0, py: 0

      @draw 0, 0

    draw: (x, y)->
      @element.transform "t #{x} #{y}"
      @_pivotVisualizer?.transform "t #{x + @pivot.px} #{y + @pivot.py}"
      @pivot =
        px: x + @pivot.px
        py: y + @pivot.py
      @

    moveTo: (coords)->
      @element.transform "t #{coords.x} #{coords.y}"
      @

    setPivotPoint: (x, y)->
      _el = @element.getBBox()
      @pivot.px = _el.x + x
      @pivot.py = _el.y + y
      @_pivotVisualizer?.transform "t #{@pivot.px } #{@pivot.py }"
      @

    showPivot: ->
      if @_pivotVisualizer? then @_pivotVisualizer.attr(opacity: 1) else throw Error messages.pivotErr
      @

    hidePivot: ->
      if @_pivotVisualizer? then @_pivotVisualizer.attr(opacity: 0) else throw Error messages.pivotErr
      @