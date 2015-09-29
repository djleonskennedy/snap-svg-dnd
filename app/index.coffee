require.config
  paths:
    Snap:       "../vendor/Snap.svg/dist/snap.svg"
    DropZone:   "./scripts/DropZone"
    Handler:    "./scripts/Handler"
    Path:       "./scripts/Path"
    Field:      "./scripts/Field"

require ['Field'], (Field)->
  new Field 1024, 768