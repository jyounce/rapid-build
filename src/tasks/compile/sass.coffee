module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	path         = require 'path'
	es           = require 'event-stream'
	gulpif       = require 'gulp-if'
	sass         = require 'gulp-sass'
	plumber      = require 'gulp-plumber'
	log          = require "#{config.req.helpers}/log"
	sassHelper   = require("#{config.req.helpers}/Sass") config, gulp
	forWatchFile = !!taskOpts.watchFile
	absCssUrls   = require "#{config.req.tasks}/format/absolute-css-urls" if forWatchFile
	extCss       = '.css'

	# streams
	# =======
	addToDistPath = (appOrRb) ->
		transform = (file, cb) ->
			fileName    = path.basename file.path
			basePath    = file.base.replace config.src[appOrRb].client.styles.dir, ''
			basePathDup = path.join basePath, basePath
			relPath     = path.join basePathDup, file.relative
			_path       = path.join config.src[appOrRb].client.styles.dir, relPath
			file.path   = _path
			cb null, file
		es.map transform

	# main task
	# =========
	runTask = (src, dest, appOrRb) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe sass().on 'data', (file) ->
				# needed for empty files. without, ext will stay .scss
				ext = path.extname file.relative
				file.path = file.path.replace ext, extCss if ext isnt extCss
			.pipe gulpif forWatchFile, addToDistPath appOrRb
			.pipe gulp.dest dest
			.on 'data', (file) ->
				return unless forWatchFile
				watchFilePath = path.relative file.cwd, file.path
				absCssUrls config, gulp, { watchFilePath }
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# helpers
	# =======
	getImports = (appOrRb) ->
		defer = q.defer()
		new sassHelper config.glob.src[appOrRb].client.styles.sass
			.setImports()
			.then (me) ->
				imports = me.getImports()
				defer.resolve imports
		defer.promise

	getWatchSrc = (appOrRb) ->
		defer = q.defer()
		new sassHelper config.glob.src[appOrRb].client.styles.sass
			.setImports()
			.then (me) ->
				src = me.getWatchSrc taskOpts.watchFile.path
				defer.resolve src
		defer.promise

	# runs
	# ====
	runWatch = (appOrRb) ->
		defer = q.defer()
		getWatchSrc(appOrRb).then (src) ->
			dest = config.dist[appOrRb].client.styles.dir
			runTask(src, dest, appOrRb).done -> defer.resolve()
		defer.promise

	run = (appOrRb) ->
		defer = q.defer()
		getImports(appOrRb).then (imports) ->
			dest = config.dist[appOrRb].client.styles.dir
			src  = config.glob.src[appOrRb].client.styles.sass
			src  = [].concat src, imports
			runTask(src, dest).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			runWatch taskOpts.watchFile.rbAppOrRb

		runMulti: ->
			defer = q.defer()
			q.all([
				run 'app'
				run 'rb'
			]).done ->
				log.task "compiled sass to: #{config.dist.app.client.dir}"
				defer.resolve()
			defer.promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()


