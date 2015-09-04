'use strict'

orApp = angular.module 'orientationw', ['ngCookies','ngRoute','ngResource']

orApp.factory 'Events', ($resource) ->
	return $resource('/api/events/:id')

orApp.config ($locationProvider, $routeProvider) ->
	$routeProvider.when('/', {
		templateUrl: '/partials/main.html',
		controller: 'MainController'
	})

	$routeProvider.when('/list/sci', {
		templateUrl: '/partials/daily-sci.html',
		controller: 'SCIDailyProgController'
	})

	$routeProvider.when('/login', {
		templateUrl: '/partials/login.html',
		controller: 'LoginController'
	})
	
	$routeProvider.otherwise({redirectTo: '/'})

	$locationProvider.html5Mode {
		enabled: true,
		requireBase: false
	} 
	$locationProvider.hashPrefix '!'

orApp.controller 'MainController', ($scope) ->
	$scope.showLogin = true
	$scope.isLoggedIn = () =>
		false

orApp.controller 'SCIDailyProgController', ($scope, Events) ->
	$scope.events = Events.query()

orApp.controller 'LoginController', ($scope, $http, $location, $cookieStore) ->
	$scope.login = {}
	$scope.signIn = =>
		alert "got login data"
		$http.post('/api/authenticate', $scope.login).
			success((loginData, status, headers, config) ->
				$location.path '/'
			).
			error((errorData, status, headers, config) ->
				$location.path '/'
			)