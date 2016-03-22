# CONFIG: TEST
# ============
module.exports = (config, opts=[]) ->
	# int test
	# ========
	test =
		watch: false
		verbose:
			tasks:   false
			jasmine: false

	# helpers
	# =======
	getWatch = ->
		opts.indexOf('watch') isnt -1

	getVerbose = ->
		vOpts = test.verbose
		for opt in opts
			continue if opt.indexOf('verbose') is -1
			vb = opt.split ':'
			if vb[0] is 'verbose' and vb.length is 1 then vOpts.jasmine = true;     break
			if vb.indexOf('*')       isnt -1 then vOpts = tasks:true, jasmine:true; break
			if vb.indexOf('tasks')   isnt -1 then vOpts.tasks   = true
			if vb.indexOf('jasmine') isnt -1 then vOpts.jasmine = true
			break
		vOpts

	# set
	# ===
	test.watch   = getWatch()
	test.verbose = getVerbose()

	# add and return
	# ==============
	config.test = test
	config



