module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

	# init inline
	# ============
	inline =
		jsHtmlImports:
			client:
				enable: options.inline.jsHtmlImports.client.enable

	# add inline to config
	# =====================
	config.inline = inline

	# logs
	# ====
	# log.json inline, 'inline ='

	# tests
	# =====
	test.log 'true', config.inline, 'add inline to config'

	# return
	# ======
	config


