define [], ()->
  class Path
    constructor: (@element, @start, @end, @className, @paper)->
      @startOfPath = @start.currentPosition
      @endOfPath = @end.currentPosition

      @element.addClass @className
      @middlePoint = @paper.circle(0, 0, 10)
      @normalPath = @paper.path()

      events = ['onHandlerMove', 'onHandlerStop', 'onHandlerSnap']
      order = ["start", "end"]

      for event in events
        for item in order
          do (item)=>
            @[item][event] = ()=>
              @["#{item}OfPath"] = @[item].currentPosition

              X1 = @[order[0] + "OfPath"].cx
              Y1 = @[order[0] + "OfPath"].cy
              X2 = @[order[1] + "OfPath"].cx
              Y2 = @[order[1] + "OfPath"].cy


              middlePointX = (X1 + X2) / 2
              middlePointY = (Y1 + Y2) / 2

              if X2 > X1
                angle = Math.atan2(Y2 - Y1, X2 - X1)
              else
                angle = Math.atan2(Y1 - Y2, X1 - X2)

#              dist = 60;
              dist = Math.sqrt(Math.pow((X2-X1), 2) + Math.pow((Y2-Y1), 2))/3
              tolerance = 0.001
              dist = dist - dist * Math.abs(X1 - X2) * tolerance

              normalX = -Math.sin(angle) * dist + middlePointX
              normalY = (Math.cos(angle) * dist + middlePointY)

              @middlePoint.attr
                stroke: "#000"
                strokeWidth: 3
                cx: middlePointX
                cy: middlePointY
#              debugger
              @normalPath.attr
                stroke: "#000"
                strokeWidth: 3
                d: "M #{middlePointX} #{middlePointY} L #{normalX} #{normalY}"

              @element.attr
                d: "M #{@["#{order[0]}OfPath"].cx} #{@["#{order[0]}OfPath"].cy} Q #{normalX} #{normalY} #{@["#{order[1]}OfPath"].cx} #{@["#{order[1]}OfPath"].cy}"

      do @update

    update: ()->
      @element.attr d: "M #{@startOfPath.cx} #{@startOfPath.cy} L #{@endOfPath.cx} #{@endOfPath.cy}"
      @