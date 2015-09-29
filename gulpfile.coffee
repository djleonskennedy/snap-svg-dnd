gulp 			  = require 'gulp'
coffee 			= require 'gulp-coffee'
connect     = require 'gulp-connect'
jade        = require 'gulp-jade'
stylus      = require 'gulp-stylus'
coffee      = require 'gulp-coffee'
clean       = require 'gulp-clean'
concat       = require 'gulp-concat'

config = require './gulp-build/config.coffee'

cathErrors = (error) ->
  console.log do error.toString
  this.emit 'end'

gulp.task 'connect', ->
  connect.server config.server

gulp.task 'copy-vendor', ->
  gulp.src "./bower_components/**/*.*"
  .pipe gulp.dest config.server.root + "/vendor"

gulp.task 'jade', ->
  gulp.src config.general.source + '**/*.jade'
  .pipe jade(
    pretty: true
  )
  .on 'error', cathErrors
  .pipe gulp.dest config.server.root
  .pipe do connect.reload

gulp.task 'stylus', ->
  gulp.src config.general.source + '**/*.styl'
  .pipe do stylus
  .on 'error', cathErrors
  .pipe gulp.dest config.server.root
  .pipe do connect.reload

gulp.task 'coffee', ->
  gulp.src [
    config.general.source + '**/*.coffee'
  ]
  .on 'error', cathErrors
  .pipe do coffee
  .pipe gulp.dest config.server.root
  .pipe do connect.reload


gulp.task 'concat-css', ->
  gulp.src('./build/css/**/*.css')
  .pipe concat('main.css')
  .pipe gulp.dest('./build/css')

gulp.task 'copy-files', ->
  gulp.src config.general.source + 'shared/**/*'
  .pipe gulp.dest './build/shared'

gulp.task 'clean', ->
  gulp.src(config.server.root, read: off).pipe do clean

gulp.task 'watch', ->
  gulp.watch config.general.source + '**/*.jade', ['jade']
  gulp.watch config.general.source + '**/*.styl', ['stylus']
  gulp.watch config.general.source + '**/*.coffee', ['coffee']
  gulp.watch config.general.source + 'shared/**/*', ['copy-files']
  gulp.watch './build/**/*.css', ['concat-css']

gulp.task 'default', [
  'jade'
  'stylus'
  'coffee'
  'concat-css'
  'copy-vendor'
  'connect'
  'copy-files'
  'watch'
]