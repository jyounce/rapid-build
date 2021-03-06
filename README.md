# rapid-build
**[rapid-build.io](https://rapid-build.io/)**  
Releases are documented here [changelog](https://github.com/rapid-build/rapid-build/blob/master/CHANGELOG.md).  
Requirements: [git](https://git-scm.com/downloads) and [Node.js](http://nodejs.org/) version >= 4.0.0


## Installation
```bash
$ npm install rapid-build -g
```


## Description
*Rapidly* develop distributable client and server side packages.
rapid-build currently supports the following technologies:
* languages
	* [css](https://developer.mozilla.org/en-US/docs/Web/CSS), [less](http://lesscss.org/) and [sass](http://sass-lang.com/) (client)
	* [html](https://developer.mozilla.org/en-US/docs/Web/HTML) (client)
	* [js](https://developer.mozilla.org/en-US/docs/Web/JavaScript),
	  [es6](https://babeljs.io/),
	  [coffeescript](http://coffeescript.org/) and
	  [typescript](https://www.typescriptlang.org/) (client and server)
* frameworks
	* [angular](https://angularjs.org/) (client)
	* [karma](http://karma-runner.github.io/) (client testing)
	* [jasmine](http://jasmine.github.io/) (client and server testing)
	* [express](http://expressjs.com/) (server)
* package managers
	* [bower](http://bower.io/) (client)
	* [npm](https://www.npmjs.com/) (client and server)

##### Key concepts:
* src
	* this is where you develop, place your working files here
	* these files should be under a [version control system](http://guides.beanstalkapp.com/version-control/intro-to-version-control.html)
	  ([ex](https://github.com/ "Example: GitHub that uses Git"))
* dist
	* this is where your distributable package will be built
	* once built you can ship them off to places like a webserver
	* these packages should not be under version control
		* instead use a [ci system](http://www.thoughtworks.com/continuous-integration "Continuous Integration System")
		  ([ex](https://travis-ci.org/ "Example: Travis CI")) to build and deploy your packages
* client
	* directory for all your
	  [client side](http://programmers.stackexchange.com/questions/171203/what-are-the-differences-between-server-side-and-client-side-programming)
	  code
* server
	* directory for all your
	  [server side](http://programmers.stackexchange.com/questions/171203/what-are-the-differences-between-server-side-and-client-side-programming)
	  code


## How To Use
Run in terminal from the root of your project.
```bash
# Run build by executing one of the following in terminal from root of your project:
# rapid-build
# rapid-build dev  | dev:test    | dev:test:client  | dev:test:server
# rapid-build prod | prod:test   | prod:test:client | prod:test:server | prod:server
# rapid-build test | test:client | test:server
# ----------------------------------------------------------------------------------
$ rapid-build
```

##### Customizing Your Builds:
* More than likely you will need to customize your builds. (No problem!)
* There are many build options available for you. (see options api)
* Create **rapid-build.json** in the root of your project.
* File name must be rapid-build and can be [cson](https://github.com/bevry/cson/blob/master/README.md), json or js file.
* Below is the basic structure for your rapid-build.json (place build options here).
	* Common options are for all build types.
	* Dev options are for default, dev and test builds.
	* Prod options are for prod build.

```json
{
	"common": {},
	"dev": {},
	"prod": {}
}
```


## Directory Structure
Must have **package.json**, everything else is optional.  
Rapid build will be expecting this directory structure.
```
dist/ (generated distributable folder created by rapid-build)
src/
├── client/
│   ├── bower_components/ (generated folder via bower.json)
│   ├── images/
│   │   └── gif, jpg, jpeg, png, svg, etc..
│   ├── libs/
│   │   └── (3rd party libraries that aren't bower components)
│   ├── scripts/
│   │   └── coffee, es6, js or typescript
│   ├── styles/
│   │   └── css, less, sass or scss
│   ├── test/
│   │   └── coffee, es6 or js
│   ├── views/
│   │   └── html
│   ├── bower.json (for bower components)
│   └── spa.html (see options.spa.src.filePath)
└── server/
    ├── test/
    │   └── coffee, es6 or js
    ├── package.json (for server node modules)
    └── routes.{coffee,es6,js,ts} (see options.dist.server.fileName)
package.json (required - must have name and version)
rapid-build.json (build options - can be cson, json or js file)
```


## Build Types
#### Common Tasks (all 4 builds do the following tasks first):
1. install bower components (if they aren't installed)
2. copy the following files to the dist directory
	* css - (client)
	* images - (client)
	* js - (client and server)
	* html - (client)
	* libs - (client) (everything in the libs directory)
	* bower components - (client) (files in every bower.json's main prop)
	* node modules - (server) (node_modules directory installed via server package.json)
	* compile then copy to dist
		* coffee -> js - (client and server)
		* es6 -> js - (client and server)
		* typescript -> js - (client and server)
		* less -> css - (client)
		* sass -> css - (client)

#### Default Build:
1. run common tasks (see above)
2. build the spa.html file then copy to dist/client/
3. start the server
4. open the browser

#### Dev Build:
1. run common tasks (see above)
2. build the spa.html file then copy to dist/client/
3. start the server
4. open the browser
5. fireup the file watchers (on saving a file, the browser will refresh)

#### Prod Build:
1. run common tasks (see above)
2. minify the application files
	* css
	* html
	* js
3. concatenate files
	* css (styles.min.css created)
	* js (scripts.min.css created)
4. build the spa.html file
5. minify the spa.html file
6. cache bust the files (client)
7. minify server js files

#### Test Build:
1. run common tasks (see above)
2. copy client test scripts to dist/client/
3. run client tests in [PhantomJS](http://phantomjs.org/)
4. copy server test scripts to dist/server/
5. run server tests using [jasmine](http://jasmine.github.io/)


## Build Options
Default builds don't suffice, no problem!  
Below are a list of options you can use to customize your builds (place in rapid-build.json).

```coffeescript
# Example: options.ports.server = 5000
# Options is an object, you can set the following properties:
# -----------------------------------------------------------
# build[client|server]                                   = (boolean) both default to true = atleast one is required to be true
# dist.dir                                               = (string)  defaults to 'dist'
# dist.client.dir                                        = (string)  defaults to 'client'
# dist.client[images|scripts|styles|test|views].dir      = (string)  defaults to property name
# dist.client.bower.dir                                  = (string)  defaults to 'bower_components'
# dist.client.libs.dir                                   = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# dist.paths.absolute                                    = (boolean) defaults to true = set to false to create relative urls instead of absolute for link tag's href, script tag's src and urls in css
# dist.server.dir                                        = (string)  defaults to 'server'
# dist.server.test.dir                                   = (string)  defaults to 'test'
# dist.server.fileName                                   = (string)  defaults to 'routes.js': this is the server's entry script
# src.dir                                                = (string)  defaults to 'src'
# src.client.dir                                         = (string)  defaults to 'client'
# src.client[images|scripts|styles|test|views].dir       = (string)  defaults to property name
# src.client.bower.dir                                   = (string)  defaults to 'bower_components'
# src.client.libs.dir                                    = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# src.server.dir                                         = (string)  defaults to 'server'
# src.server.test.dir                                    = (string)  defaults to 'test'
# ports.server                                           = (int)     defaults to 3000, web server port
# ports.reload                                           = (int)     defaults to 3001, browsersync server port
# ports.reloadUI                                         = (int)     defaults to 3002, browsersync's user-interface server port
# ports.test                                             = (int)     defaults to 9876, karma server port
# order[scripts|styles][first|last]                      = (array of strings) = file paths
# angular.modules                                        = (array of strings) = additional angular modules to load, already loaded are ['ngResource', 'ngRoute', 'ngSanitize'] and 'ngMockE2E' based on angular.httpBackend options
# angular.moduleName                                     = (string)  defaults to 'app' = application module name, value for ng-app
# angular.version                                        = (string)  defaults to '1.x' = semver version required
# angular.bootstrap                                      = (boolean or string) defaults to false = bootstrap angular instead of using ng-app in spa.html, provide true to bootstrap on document or provide a css selector to bootstrap on a dom element
# angular.httpBackend.dev                                = (boolean) defaults to false = set to true to enable httpBackend for dev and default build
# angular.httpBackend.prod                               = (boolean) defaults to false = set to true to enable httpBackend for prod build
# angular.httpBackend.dir                                = (string)  defaults to 'mocks' = directory inside your client scripts directory
# angular.templateCache.dev                              = (boolean) defaults to false = use template cache when running default and dev task
# angular.templateCache.urlPrefix                        = (string)  prefix for template urls
# angular.templateCache.useAbsolutePaths                 = (boolean) defaults to false = prefix template urls with a '/'
# angular.ngFormify                                      = (boolean) defaults to false = set to true to replace all html form tags with ng:form in client dist, useful if your application is going to be wrapped in a global form
# spa.autoInject                                         = (array of strings) defaults to ['all'] = the build will automatically inject the following into your spa.html: ['clickjacking', 'moduleName', 'ngCloakStyles', 'scripts', 'styles'], set to false to disable or provide options you want injected
# spa.title                                              = (string)  defaults to package.json name or 'Application' = html title tag value
# spa.description                                        = (string)  defaults to package.json description = html meta description tag value
# spa.src.filePath                                       = (string)  set if you want to use your own spa file and not the build system's (file must be located in your client src directory)
# spa.dist.fileName                                      = (string)  defaults to file name of spa.src.filePath or 'spa.html' = provide if you want the dist spa file to be named differently, example: 'index.html'
# spa.placeholders                                       = (array of strings) = set to retain spa file placeholders, optional values are: ['clickjacking', 'description', 'moduleName', 'ngCloakStyles', 'scripts', 'styles', 'title'] or ['all']
# spa[scripts|styles].attrs                              = (object) = set to add additional attributes to the link (styles) and script tags that the build outputs in spa.html or modify the default attributes: scripts = { src }, styles = { rel, href }
# minify.cacheBust                                       = (boolean) defaults to true = for prod build, ensures the user always receives the latest files, adds an md5 checksum to the client files before their extension
# minify.css.styles                                      = (boolean) defaults to true = for prod build, minify the css
# minify.css.fileName                                    = (string)  defaults to 'styles.min.css' = provide to name the minified css file differently
# minify.css.splitMinFile                                = (boolean) defaults to false = for prod build, task for ie9 and below, split styles.min.css into multiple files if selector count > 4,095
# minify.html.views                                      = (boolean) defaults to true = for prod build, minify the html
# minify.html.templateCache                              = (boolean) defaults to true = for prod build, use the template cache
# minify.html.options                                    = (object)  defaults to { collapseWhitespace: true, removeComments: true, removeEmptyElements: false, removeEmptyAttributes: false } for details see: https://git.io/vVyAC
# minify.spa.file                                        = (boolean) defaults to true = for prod build, minify the spa.html file
# minify.server.json.enable                              = (boolean) defaults to true = set to false to not minify your server json files
# minify.client.js.fileName                              = (string)  defaults to 'scripts.min.js' = provide to name the minified js file differently
# minify[client|server].js.enable                        = (boolean) defaults to true = set to false to not minify your js client and or server files
# minify[client|server].js.es6                           = (boolean) defaults to false = set to true if your js files are written in ES6+
# minify[client|server].js.options                       = (object)  default minifier is ES5 = set to configure the minifier, find available options here: ES5 (https://git.io/vFbk9) or ES6+ (https://git.io/vFbkj)
# exclude.spa                                            = (boolean) defaults to false = set to true to exclude spa.html from client dist
# exclude.angular.files                                  = (boolean) defaults to false = set to true to exclude the angular files that come with rapid-build from dist (lib and modules)
# exclude.angular.modules                                = (boolean) defaults to false = set to true to exclude injecting the angular modules that come with rapid-build ['ngResource', 'ngRoute', 'ngSanitize']
# exclude.default.client.files                           = (boolean) defaults to false = set to true to exclude the client files rapid-build sends to the dist client directory
# exclude.default.server.files                           = (boolean) defaults to false = set to true to exclude the server files rapid-build sends to the dist server directory
# exclude.from.cacheBust                                 = (array of strings) = file paths: exclude files from the cache bust
# exclude.from.minFile[scripts|styles]                   = (array of strings) = file paths: exclude script or style files from automatically being generated in the scripts.min.js or styles.min.css file
# exclude.from.spaFile[scripts|styles]                   = (array of strings) = file paths: exclude script or style files from automatically being generated in the spa.html file
# exclude.from.spaFile.angular.files                     = (boolean) defaults to false = set to true to exclude the angular files from spa.html the build includes (angular library and modules ngResource, ngRoute and ngSanitize)
# exclude.from.dist[client|server]                       = (array of strings) = file paths: exclude client or server files from the dist folder
# test.client.browsers                                   = (array of browser names) = phantomjs will run by default, optional browser names are ['chrome', 'firefox', 'ie', 'safari']
# httpProxy                                              = (array of objects) = object format: { context: array or string, options: object } for details see: https://git.io/vVyA0
# browser.open                                           = (boolean) defaults to true = open the browser once the build completes, applies to builds: default, dev and prod:server
# browser.reload                                         = (boolean) defaults to true = reloads the browser once you save your src file, only applies to dev builds
# extra.copy[client|server]                              = (array of strings) = file paths: additional files to copy to dist/client and or dist/server that the build didn't copy
# extra.compile.client[coffee|es6|htmlScripts|less|sass] = (array of strings) = file paths: additional files to compile to dist/client that the build didn't compile
# extra.compile.server[less|sass]                        = (array of strings) = file paths: additional files to compile to dist/server that the build didn't compile
# extra.minify.client[css|js]                            = (array of strings) = file paths: additional files to minify in dist/client that the build didn't minify (by default, the build does not minify files in libs or bower_components)
# extra.watch[client|server]                             = (array of strings) = file paths: additional files to watch in src/client and or src/server that the build didn't watch
# security.client.clickjacking                           = (boolean) defaults to true = includes a clickjacking defense script in the default spa.html (set to false to disable)
# inline.htmlAssets.enable                               = (boolean) defaults to false = set to true to inline html assets
# inline.htmlAssets.dev                                  = (boolean) defaults to false = set to true to run on dev build
# inline.htmlAssets.options.attribute                    = (string) by default all html assets will be inlined unless an attribute name is provided (place attribute name on html tags/assets you wish to inline)
# inline.htmlAssets.options.svgAsImage                   = (boolean) defaults to false = set to true to convert <img src="*.svg"> to <img> and not <svg> tag
# inline.htmlAssets.options.ignore                       = (array of strings) disable inlining based on file extension and/or html tag
# inline.jsHtmlImports.client.enable                     = (boolean) defaults to false = set to true to inline js html imports
# compile.htmlScripts.client.enable                      = (boolean) defaults to false = set to true to compile inline html scripts that have es6 code to es5
# compile.typescript[client|server].enable               = (boolean) defaults to false = set to true to enable client and or server typescript compiler
# compile.typescript.client.entries                      = (array of strings) defaults to ['main.ts'] = Entry point(s) of your app. This file(s) is required. Browserify is used for module loading. Must use commonjs for typescript's module code generation.
# ==========================================================================================================================================================================================================================================================================================================
```


## Develop Rapidly!
![Shake and Bake!](https://raw.githubusercontent.com/rapid-build/rapid-build.io/master/src/client/images/shake-and-bake.jpg "Shake n' Bake!")

