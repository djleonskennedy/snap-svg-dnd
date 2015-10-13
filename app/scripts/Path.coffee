define [], ()->
  class Path
    constructor: (@element, @start, @end, @className)->
      @startOfPath = @start.currentPosition
      @endOfPath = @end.currentPosition

      @element.addClass @className

      events = ['onHandlerMove', 'onHandlerStop', 'onHandlerSnap']
      order = ["start", "end"]

      for event in events
        for item in order
          do (item)=>
            @[item][event] = ()=>
              @["#{item}OfPath"] = @[item].currentPosition
              @element.attr
                d: "M #{@["#{order[0]}OfPath"].cx} #{@["#{order[0]}OfPath"].cy} L #{@["#{order[1]}OfPath"].cx} #{@["#{order[1]}OfPath"].cy}"

      do @update

    update: ()->
      @element.attr d: "M #{@startOfPath.cx} #{@startOfPath.cy} L #{@endOfPath.cx} #{@endOfPath.cy}"
      @