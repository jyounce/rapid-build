module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	promiseHelp  = require "#{config.req.helpers}/promise"
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = ->
		tasks.run.async(
			config, runTask,
			'images', 'all',
			['client']
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}copy-images", ->
		return promiseHelp.get() unless config.build.client
		runMulti()