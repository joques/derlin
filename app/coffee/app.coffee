'use strict'

orApp = angular.module 'orientationw', ['ngCookies', 'ngResource', 'ngRoute', 'mm.foundation', 'ngInfiniteScroll']

orApp.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
	$routeProvider.when '/',
		templateUrl: 'partials/main.html'
		controller: 'MainController'

	$routeProvider.otherwise
		redirectTo: '/'

	$locationProvider.html5Mode true
]

angular.element(document).ready () ->
	angular.bootstrap document, ['orientationw']