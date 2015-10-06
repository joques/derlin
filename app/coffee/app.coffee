'use strict'

# need to bring back the infinite scroll package

orApp = angular.module 'orientationw', ['ngCookies','ngRoute','ngResource', 'infinite-scroll']

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

orApp.controller 'MainController', ($scope, $cookieStore) ->
	$scope.showLogin = true
	$scope.isLoggedIn = () =>
		username = $cookieStore.get 'username'
		return username?

orApp.controller 'SCIDailyProgController', ($scope, Events) ->
	$scope.events = Events.query()
	$scope.

orApp.controller 'LoginController', ($scope, $http, $location, $cookieStore) ->
	$scope.login = {}
	$scope.signIn = =>
		alert "got login data"
		alert $scope.login.username
		alert $scope.login.password
		$http.post('/api/authenticate', JSON.stringify($scope.login)).
			success((loginData, status, headers, config) ->
				$cookieStore.put 'username', loginData.user
				$location.path '/'
			).
			error((errorData, status, headers, config) ->
				alert "Authentication failed: #{errorData.error}"
				$cookieStore.put 'username', undefined
				$location.path '/'
			)