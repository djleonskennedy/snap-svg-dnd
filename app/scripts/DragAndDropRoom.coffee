define [], ()->
  class DragAndDropRoom
    constructor: ()->
      @dragAreas = []
      @handlers = []

    registerArea: ( dropArea )->
      dropArea.assignedTo = @
      @dragAreas.push dropArea

    registerHandler: ( handler )->
      handler.assignedTo = @
      @handlers.push handler

    launchRoom:->
      console.log @dragAreas
      console.log @handlers