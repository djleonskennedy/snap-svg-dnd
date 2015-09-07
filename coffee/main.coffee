class Observer
  constructor:()->
    @_events = {}

  on: (eventName, fn)->
    @_events[eventName] = @_events[eventName] || []
    @_events[eventName].push fn

  off: (eventName, fn)->
    if @_events[eventName]
      i = 0
      while i < @_events[eventName].length
        if @_events[eventName][i] == fn
          @_events[eventName].splice i, 1
          break
        i++

  emmit: (eventName, data)->
    if @_events[eventName]
      @_events[eventName].forEach (fn)->
        fn data

#single tone
STO = do ->
  instance = undefined

  createInstance = ->
    object = new Observer()
    object

  { getInstance: ->
    if !instance
      instance = createInstance()
    instance
  }

# HANDLER CLASS
class Handler
  constructor: (@element)->
    @visibleElement = null
    @element[0].addClass('connectors')
    @element.drag @move, @start, @stop
    @initialCoordsString = null
    @attached = false

  draw:(attributes)->
    @matrix = new Snap.matrix

    @matrix.translate(attributes[0], attributes[1])
    @element.transform(@matrix)
    @

  snapTo : (el)=>
    @element.transform "t #{el.pivot.px} #{el.pivot.py}"

  updateCoords: (_this)-> STO.getInstance().emmit("onHandlerStop", _this)

  start: (x, y, ev) =>
    if typeof x == 'object' and x.type == 'touchstart'
      x.preventDefault()
      @element.data 'ox', x.changedTouches[0].clientX
      @element.data 'oy', x.changedTouches[0].clientY
    @element.data 'origTransform', @element.transform().local
    @initialCoordsString = @matrix.toTransformString()

  stop:()=>
    @updateCoords @

  move: (dx, dy, x, y, e) =>
    _el = @element.getBBox()
    sto = STO.getInstance()

    if typeof dx == 'object' and dx.type == 'touchmove'
      changedTouches = dx.changedTouches[0]
      dx = changedTouches.clientX - @element.data('ox')
      dy = changedTouches.clientY - @element.data('oy')

    @element.transform "#{@element.data('origTransform')} t #{dx} #{dy}"

    if @element[0].type == "circle"
      sto.emmit('onIonicUpdate')
    else
      sto.emmit('onCovalentUpdate')

# PORT CLASS
class Port
  constructor: (@element)->
    @connected = null
    @element.addClass('ports')

    #transformation matrix for the element
    @matrix = new Snap.matrix

    #pivot point for snap hanlder to this port
    @pivot = null

    #helper for checking wether port is available
    @free = true

  draw:(attributes)->
    @pivot =
      px: attributes[0]
      py: attributes[1]

    @matrix.translate(attributes[0], attributes[1])
    @element.transform(@matrix)
    @

  moveTo: (coords)->
    @element.transform "t #{coords[0]} #{coords[1]}"
    @

  setPivotPoint: (coords)->
    @pivot.px = coords[0]
    @pivot.py = coords[1]
    @

#PATH CLASS
class Path
  constructor: (@element, @className)->
    @element.addClass(@className)

  draw:(attributes, element)->
    @element.attr d: attributes
    @

do ->
  @currentSVGState = "initial"

  paper = Snap('#svg')

  template = window._drawSVG()
  template.getTemplate paper, @text, @

  #states
  @svgState = {}

  @svgState.initial = () =>
    window[@slideid].classList.add "initial-image"
    window[@slideid].classList.remove "final-image"
    _portsCoords       = [[141, 99], [234, 164], [240, 50], [224, 143]]
    _portsPivots       = [[141, 99], [234, 164], [251, 65], [236, 159]]
    template.set {x: 118, y: 70}, {x: 118, y: 164}, "initial", {description: @text.factor, coords: {x: 119, y: 268}}, @
    @molecule.setStability 5
    @molecule.setRisk 0
    @molecule.setHalf 0
    @currentSVGState = "initial"
    ports?.forEach (port, index)->
      port.moveTo _portsCoords[index]
      port.setPivotPoint _portsPivots[index]
      port.connected?.snapTo port if port.connected?.attached
      do updateIonicPath
      do updateCovalentPath
      ionicDescription.attr x: 10, y: 6
      covalentDescription.attr x: 0, y: 0
    covalentDescription.transform("t 247 315")

  @svgState.initialWithoutReset = () ->
    ports?.forEach (port)->
      if port.free
        do updateIonicPath
        do updateCovalentPath

  @svgState.ionic = ()=>
    window[@slideid].classList.remove "final-image"
    window[@slideid].classList.add "initial-image"
    _portsCoords = [[190, 99], [180, 165], [286, 50], [165, 145]]
    _portsPivots = [[191, 99], [179, 164], [300, 65], [181, 159]]
    template.set {x: 168, y: 70}, {x: 63, y: 164}, "ionic", {description: @text.fullChain, coords: {x: 170, y: 265}}, @
    @molecule.setStability 90
    @molecule.setRisk 44
    @molecule.setHalf 32
    @molecule.$halfLife.style.webkitTransform = "scaleX(0.36)"
    @currentSVGState = "ionic"
    ports.forEach (port, index)->
      port.moveTo _portsCoords[index]
      port.setPivotPoint _portsPivots[index]
      port.connected?.snapTo port if port.connected?.attached
      do updateIonicPath
      do updateCovalentPath
      ionicDescription.attr x: 58, y: -16
      covalentDescription.attr x: 0, y: 0
    covalentDescription.transform("t 247 315")

  @svgState.covalent = ()=>
    window[@slideid].classList.add "final-image"
    window[@slideid].classList.remove "initial-image"
    _portsCoords = [[357, 165], [136, 165], [190, 146], [124, 146]]
    _portsPivots = [[357, 165], [136, 165], [207, 162], [138, 162]]
    template.set {x: 230, y: 166}, {x: 20, y: 165}, "covalent", {description: @text.singleChain, coords: {x: 164, y: 265}}, @
    @molecule.setStability 175
    @molecule.setRisk 16
    @molecule.setHalf 54
    @currentSVGState = "covalent"


    ports.forEach (port, index)->
      port.moveTo _portsCoords[index]
      port.setPivotPoint _portsPivots[index]
      if port.connected?.attached
        port.connected.snapTo port


    handlers[0].port = ports[0]
    handlers[1].port = ports[1]

    ports[0].connected = handlers[0]
    ports[1].connected = handlers[1]

    handlers[0].element.transform "t 357 166"
    handlers[1].element.transform "t 136 165"

    updateIonicPath "M354 160 C 280 120 210 120 135 160"

    do updateCovalentPath
    ionicDescription.attr x: 10, y: -35
    covalentDescription.attr x: 13, y: -10
    covalentDescription.transform("t 152 205")

  ###   CREATING PATHs   ###
  ionicPath = new Path(paper.path("").attr {strokeDasharray: "3, 3", strokeWidth: 2, stroke: '#5f5f5f', fill: "transparent"}, 'ionic-path').draw("M90 300 L170 300", null)
  covalentPath = new Path(paper.path(""), 'covalent-path').draw("M239 301 L315 301", null)

  ###   CREATING DESCRs   ###
  ionicDescription = paper.text(10, 6, @text.ionicBond.text).addClass('path-desctiprion')
  ionicElipse = paper.ellipse(30, -18, 22, 12, @text.ionicBond.text).addClass('ionic-ellipse')
  ionicM = paper.text(21, -13, @text.ionicBond.ionic[0]).addClass('ionic-m')
  ionicSup = paper.text(39, -18, @text.ionicBond.ionic[1]).addClass('ionic-sup')

  ionicG = paper.group( ionicDescription, ionicElipse, ionicM, ionicSup )
  ionicG.transform("t 100 320")

  covalentDescription = paper.text(0, 0, @text.covalentBond.text).addClass('path-desctiprion')
  covalentDescription.transform("t 247 324")


  _portsInit           = [paper.circle(0,0,40), paper.circle(0,0,40), paper.rect(0,0,70,70), paper.rect(0,0,70,70)]
  _portsInitData       = [[141, 99], [234, 164], [240, 50], [224, 143]]
  _portsPivots         = [[141, 99], [234, 164], [251, 65], [236, 159]]

  _handlersInitData    = [[90, 300], [169, 300], [216, 281], [293, 281]]
  _handlersInit        = [
    paper.group(paper.circle(0, 0, 20), paper.circle(0,0,5).addClass('visible-connector'))
    paper.group(paper.circle(0, 0, 22), paper.circle(0,0,5).addClass('visible-connector'))
    paper.group(paper.rect(0, 0, 40, 40), paper.rect(16,16,8,8).addClass('visible-connector').transform("r45"))
    paper.group(paper.rect(0, 0, 40, 40), paper.rect(16,16,8,8).addClass('visible-connector').transform("r45"))
  ]

  ports = []
  handlers = []
  do @svgState.initial

  _portsInit.forEach (item, index)->
    ports.push new Port(item).draw([_portsInitData[index][0], _portsInitData[index][1]]).setPivotPoint(_portsPivots[index])
    handlers.push new Handler(_handlersInit[index]).draw([_handlersInitData[index][0], _handlersInitData[index][1]])

  _parseCoords = (el)->
    _el = el.element.getBBox()
    return {
      x: _el.x
      y: _el.y
      w: _el.x + _el.w
      h: _el.y + _el.h
    }

  updateCovalentPath = do () ->
    h3 = handlers[2].element
    h4 = handlers[3].element
    return ()->
      _h3 = h3.getBBox()
      _h4 = h4.getBBox()
      covalentPath.element.attr d: "M#{_h3.cx} #{_h3.cy} L#{_h4.cx} #{_h4.cy}"

  updateIonicPath = do ()->
    h1 = handlers[0].element
    h2 = handlers[1].element
    _ionicPathNode = ionicPath.element.node
    return (state)->
      _h1 = h1.getBBox()
      _h2 = h2.getBBox()
      _h1cx = _h1.cx
      _h1cy = _h1.cy
      _h2cx = _h2.cx
      _h2cy = _h2.cy

      startLine = "M #{_h1cx} #{_h1cy}"
      curve = "C #{_h1cx} #{_h1cy} #{_h2cx} #{_h2cy}"
      closeLine = "#{_h2cx} #{_h2cy}"
      pathString = state || "#{startLine} #{curve} #{closeLine}"

      ionicPath.element.attr d: pathString

      elementPos = _ionicPathNode.getPointAtLength(_ionicPathNode.getTotalLength() / 2)
      ionicG.transform("t #{elementPos.x - 30}, #{elementPos.y + 20}")

  requestCoords = (currentHanler)->

    _this = currentHanler
    _el = _this.element.getBBox()
    range = (val, min, max) ->
      val >= min and val <= max
    for port in ports

      _this.attached = false
      coord = _parseCoords(port)
      if port.free and range(_el.cx, coord.x, coord.w) and range(_el.cy, coord.y, coord.h) and _this.element[0].type == port.element.type

        _this.attached = true
        _this.port?.free = true
        _this.port = port
        port.free = false

        #setting pivots
        _this.snapTo port
        port.connected = _this
        break

    if not _this.attached

      _this.port?.free = true
      _this.element.transform _this.initialCoordsString
      do updateIonicPath
      do updateCovalentPath

    #update state
    do updateState

  updateState = ()=>
    ionic = 0
    covalent = 0
    handlers.forEach (handler)->
      if handler.element[0].type == 'circle' and handler.attached
        ionic++
      if handler.element[0].type == 'rect' and handler.attached
        covalent++
    if ionic == 2
      if @currentSVGState != 'ionic'
        STO.getInstance().emmit("UpdateState", 'ionic')
      if covalent == 2 and @currentSVGState != 'covalent'
        STO.getInstance().emmit("UpdateState", 'covalent')
      else
        do @svgState.initialWithoutReset
    else
      if @currentSVGState == 'ionic' or @currentSVGState == 'covalent'
        STO.getInstance().emmit("UpdateState", 'initial')
      else
        do @svgState.initialWithoutReset

  setState = (state)=> do @svgState[state]

  #events
  STO.getInstance().on("onIonicUpdate", updateIonicPath)
  STO.getInstance().on("onCovalentUpdate", updateCovalentPath)
  STO.getInstance().on("UpdateState", setState)
  STO.getInstance().on("onHandlerStop", requestCoords)
