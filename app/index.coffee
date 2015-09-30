require.config
  paths:
    Snap:               "../vendor/Snap.svg/dist/snap.svg"
    DragAndDropRoom:    "./scripts/DragAndDropRoom"
    DropArea:           "./scripts/DropArea"
    Handler:            "./scripts/Handler"
    Path:               "./scripts/Path"
    Field:              "./scripts/Field"

require ['Field'], (Field)->
  new Field 1024, 768