app = angular.module('orientationw')
app.controller('MainController', MainController)

MainController = ($scope, $cookieStore) ->
	$scope.name = {}
	$scope.loggedIn = () ->
		return false