'use strict'

orApp = angular.module 'orientationw', ['ngRoute', 'ngResource', 'mm.foundation', 'infinite-scroll']

orApp.config(['$routeProvider', ($routeProvider) ->
	$routeProvider.when('/', {
		templateUrl: 'partials/main.html',
		controller: 'FirstController'
		})
	
	$routeProvider.otherwise({redirectTo: '/'})
	])

orApp.controller('FirstController', ['$scope', ($scope) ->
	$scope.showLogin = true
	$scope.isLoggedIn = () =>
		false
	])