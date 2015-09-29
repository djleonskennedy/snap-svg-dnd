define [], ->
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