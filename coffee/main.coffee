_utils =
  events :
    events: {}
    on: (eventName, fn) ->
      @events[eventName] = @events[eventName] or []
      @events[eventName].push fn

    off: (eventName, fn) ->
      if @events[eventName]
        i = 0
        while i < @events[eventName].length
          if @events[eventName][i] == fn
            @events[eventName].splice i, 1
            break
          i++

    emit: (eventName, data) ->
      if @events[eventName]
        @events[eventName].forEach (fn) ->
          fn data

  _range : (val, min, max) ->
    val >= min and val <= max

paper = Snap('#svg')

pinkStyle =
  fill: "#f0f"

lock = true

_compaire = (el, e, fn)->
  compaired = 0
  if _utils._range e.layerX, el.cx, (el.cx + el.w)
    ++compaired
  if _utils._range e.layerY, el.cy, (el.cy + el.h)
    ++compaired
  if compaired == 2
    fn true
  else
    fn false

move = (dx, dy, x, y) ->
  clientX = null
  clientY = null
  if typeof dx == 'object' and dx.type == 'touchmove'
    clientX = dx.changedTouches[0].clientX
    clientY = dx.changedTouches[0].clientY
    dx = clientX - @data('ox')
    dy = clientY - @data('oy')
  @attr transform: @data('origTransform') + (if @data('origTransform') then 'T' else 't') + [dx,dy]

start = (x, y, ev) ->
  if typeof x == 'object' and x.type == 'touchstart'
    x.preventDefault()
    @data 'ox', x.changedTouches[0].clientX
    @data 'oy', x.changedTouches[0].clientY
  @data 'origTransform', @transform().local

stop = (e) ->
  _handlers = [firstHandler01, firstHandler02, secondHandler01, secondHandler02]

  _handlers.forEach (_handler, i, arr)->
    _compaire _handler.getBBox(), e, ( compaired )=>
      handler @data('requires'), _handler.data('requires'), compaired
  , @

_state =
  firstHandler : 0
  secondHandler : 0

handler = (required, actual, compaired)->
  if compaired
    if required is actual
      if _state[actual.slice 0, -2] < 2
        _state[actual.slice 0, -2] += 1
  else
    if _state[actual.slice 0, -2] > 0
      _state[actual.slice 0, -2] -= 1


      # _state[actual.slice 0, -2] -= 1

  do updateState


updateState = (state)->
  console.log _state

firstHandler01 = paper.circle(20,80,20)
  .attr pinkStyle
  .data 'requires', 'firstHandler01'

firstHandler02 = paper.circle(100,80,20)
  .attr pinkStyle
  .data 'requires', 'firstHandler02'

secondHandler01 = paper.rect(150,80,40,40)
  .attr pinkStyle
  .data 'requires', 'secondHandler01'

secondHandler02 = paper.rect(200,80,40,40)
  .attr pinkStyle
  .data 'requires', 'secondHandler02'

paper.circle(20,20,20)
  .data 'requires', 'firstHandler01'
  .drag move, start, stop

paper.circle(40,20,20)
  .data 'requires', 'firstHandler02'
  .drag move, start, stop

paper.rect(60,20,40,40)
  .data 'requires', 'secondHandler01'
  .drag move, start, stop

paper.rect(90,20,40,40)
  .data 'requires', 'secondHandler02'
  .drag move, start, stop