module.exports = (gulp, config) ->
	q           = require 'q'
	coffee      = require 'gulp-coffee'
	plumber     = require 'gulp-plumber'
	promiseHelp = require "#{config.req.helpers}/promise"
	extraHelp   = require("#{config.req.helpers}/extra") config

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

	runTasks = ->
		extraHelp.run.tasks.async runTask, 'compile', 'coffee', ['client']

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}compile-extra-coffee", ->
		return promiseHelp.get() unless config.build.client
		runTasks()