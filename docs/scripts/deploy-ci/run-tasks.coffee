module.exports = (docsRoot) ->
	path  = require 'path'
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	tasks = path.join __dirname, 'tasks'

	# tasks
	# =====
	decryptKey             = require "#{tasks}/decrypt-deploy-key"
	addDeployKey           = require "#{tasks}/add-deploy-key"
	disableHostKeyChecking = require "#{tasks}/disable-host-key-checking"
	setGitConfigUser       = require "#{tasks}/set-git-config-user"
	gitClone               = require "#{tasks}/git-clone"
	moveGitAndCleanTemp    = require "#{tasks}/move-git-and-clean-temp"
	buildProd              = require "#{tasks}/build-prod"
	gitCommitPushAndTag    = require "#{tasks}/git-commit-push-and-tag"

	# run tasks
	# =========
	runTasks = async ->
		res1 = await decryptKey docsRoot
		res2 = await addDeployKey docsRoot
		res3 = await disableHostKeyChecking docsRoot
		res4 = await setGitConfigUser docsRoot
		res5 = await gitClone docsRoot
		res6 = await moveGitAndCleanTemp docsRoot
		res7 = await buildProd docsRoot
		res8 = await gitCommitPushAndTag docsRoot
		res  = [res1, res2, res3, res4, res5, res6, res7, res8]
		res.filter(Boolean).join '\n'

	# run it!
	# =======
	runTasks()
