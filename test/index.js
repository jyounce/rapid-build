/* Register Coffee
 * Get Config
 * Run Tests
 ******************/
require('coffee-script/register');
var config = require('../core/config')();
require(config.paths.abs.test.init)(config);