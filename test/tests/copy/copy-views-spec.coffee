# spec: copy-views
# ================
task   = 'copy-views'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	tests.run.spec '/copy/copy-html'


