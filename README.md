# rapid-build

**Under Development (not for use yet)**

## Installation
```bash
$ npm install rapid-build
```

## Information
rapid-build depends on [npm](http://npmjs.org/) and [Node.js](http://nodejs.org/) version >= 0.10.0

## More documentation coming real soon!
This will get you started:

```javascript
var config = {} // optional config, documentation coming soon
var rapid = require('rapid-build')(config) // init to pass in config options

// rapid returns a promise and has 1 optional param 'dev' or 'prod'
rapid().then(function() {
	console.log('whatever you want')
})
```
OR

```javascript
/**
 * if you are using gulp
 * in your gulpfile.js (there are 3 available tasks)
 * first require rapid-build and provide it gulp
 */
var gulp = require('gulp')
var config = {} // optional config, documentation coming soon
require('rapid-build')(gulp, config)

// as a gulp task dependency
gulp.task('default', ['rapid-build'])

// or from the terminal type one of the 3:
gulp rapid-build
gulp rapid-build:dev
gulp rapid-build:prod
```
#### Develop Rapidly!
![Shake and Bake!](docs/shake-and-bake.jpg)
