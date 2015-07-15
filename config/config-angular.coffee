module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# default modules
	# order matters because of 'ngMockE2E'
	# ====================================
	modules = ['ngMockE2E', 'ngResource', 'ngRoute', 'ngSanitize']

	# init angular
	# ============
	angular = {}

	# httpBackend
	# ===========
	httpBackendDir = options.angular.httpBackend.dir or 'mocks'
	httpBackendDir = path.join config.src.app.client.scripts.dir, httpBackendDir
	angular.httpBackend = {}
	angular.httpBackend.dev  = options.angular.httpBackend.dev or false
	angular.httpBackend.prod = options.angular.httpBackend.prod or false
	angular.httpBackend.dir  = httpBackendDir

	# modules
	# =======
	angular.modules = options.angular.modules or []
	angular.modules = modules.concat angular.modules

	# version
	# =======
	angular.version = options.angular.version or '1.x'

	# module name
	# ===========
	angular.moduleName = options.angular.moduleName or 'app'

	# template cache
	# ==============
	angular.templateCache = {}
	angular.templateCache.dev              = options.angular.templateCache.dev or false
	angular.templateCache.useAbsolutePaths = options.angular.templateCache.useAbsolutePaths or false

	# rb bower dependencies
	# =====================
	angular.bowerDeps =
		'angular':          angular.version
		'angular-mocks':    angular.version
		'angular-resource': angular.version
		'angular-route':    angular.version
		'angular-sanitize': angular.version

	# methods
	# =======
	removeRbMocksModule = -> # helper
		angular.modules.splice 0, 1

	angular.removeRbMocksModule = ->
		return if config.env.is.test
		if config.env.is.prod
			removeRbMocksModule() if not angular.httpBackend.prod
		else if not angular.httpBackend.dev
			removeRbMocksModule()

	# add angular to config
	# =====================
	config.angular = angular

	# logs
	# ====
	# log.json angular, 'angular ='

	# tests
	# =====
	test.log 'true', config.angular, 'add angular to config'

	# return
	# ======
	config


