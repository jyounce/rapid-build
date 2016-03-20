# test: coffee:client
# ===================
spec   = 'coffee'
task   = "#{spec}:client"
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} task", ->
	tests.run.task task
	tests.run.spec "/compile/#{spec}"
