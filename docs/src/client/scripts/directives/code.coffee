angular.module('rapid-build').directive 'rbCode', ['$compile', 'preService',
	($compile, preService) ->
		# helpers
		# =======
		help =
			compile: (text, scope, element) ->
				element.text text
				element.attr 'hljs', ''
				element.attr 'hljs-language', scope.syntax
				element.attr 'hljs-interpolate', true if scope.interpolate
				$compile(element) scope.$parent

		# link
		# =======
		link = (scope, element, attrs, controller, transcludeFn) ->
			scope.syntax      = 'javascript' unless scope.syntax
			scope.interpolate = attrs.interpolate isnt undefined

			transcludeFn (clone) ->
				elm  = clone[0]
				return unless elm
				text = elm.textContent
				return unless text.trim()
				text = preService.get.text text
				help.compile text, scope, element

		# API
		# ===
		link: link
		replace: true
		transclude: true
		templateUrl: '/views/directives/code.html'
		scope:
			display: '@'
			syntax: '@'
			# valueless attrs:
			# interpolate: '@'
]



