module.exports = (config, gulp, taskOpts={}) ->
	q         = require 'q'
	coffee    = require 'gulp-coffee'
	plumber   = require 'gulp-plumber'
	extraHelp = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe coffee bare: true
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "compiled extra coffee to #{appOrRb} #{loc}".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			extraHelp.run.tasks.async runTask, 'compile', 'coffee', [loc]

	# return
	# ======
	api.runTask taskOpts.loc