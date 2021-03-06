through     = require 'through2'
PluginError = require 'plugin-error'
PLUGIN_NAME = 'gulp-update-file-base'

# Plugin level function(dealing with files)
# Effects gulp.dest(dest).
# Ensure file copies to correct dist location.
# ============================================
updateFileBase = (fileBase) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless fileBase
		return cb null, file unless file
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		file.base = fileBase
		cb null, file

module.exports = updateFileBase