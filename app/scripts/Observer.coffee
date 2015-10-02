define [], ->
  class Observer
    constructor:()->
      @_events = {}

    on: (eventName, fn)->
      @_events[eventName] = @_events[eventName] || []
      @_events[eventName].push fn

    off: (eventName, fn)->
      if @_events[eventName]
        @_events[eventName] = @_events[eventName].filter (item)-> item if item is fn

    emmit: (eventName, data)->
      if @_events[eventName]
        @_events[eventName].forEach (fn)->
          fn data