<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>todo Management</title>
<script
	src="//ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script type="text/javascript">
	var app = angular.module('myapp', []);

	app.controller('myappcontroller', function($scope, $http) {
		$scope.todos = []
		$scope.userform = {
			id : "",
			title : ""			
		};
		
		getUserDetails();

		function getUserDetails() {
			$http({
				method : 'GET',
				url : 'todos/'
			}).then(function successCallback(response) {
				$scope.todos = response.data;
			}, function errorCallback(response) {
				console.log(response.statusText);
			});
		}

		$scope.processUser = function() {
			$http({
				method : 'POST',
				url : 'todos/',
				data : angular.toJson($scope.userform),
				headers : {
					'Content-Type' : 'application/json'
				}
			}).then(getUserDetails(), clearForm())
			  .success(function(data){
				$scope.todos= data
		    });
		}
		$scope.editUser = function(todo) {
			$scope.userform.id = todo.id;
			$scope.userform.title = todo.title;
			$scope.userform.status = todo.status;
			disableName();
		}
		$scope.deleteUser = function(todo) {
			$http({
				method : 'DELETE',
				url : 'todos/',
				data : angular.toJson(todo),
				headers : {
					'Content-Type' : 'application/json'
				}
			}).then(getUserDetails(), clearForm())
			  .success(function(data){
					$scope.todos= data
			    });
		}
		$scope.statuschange = function(todo) {
			$http({
				method : 'PUT',
				url : 'todostatus/',
				data : angular.toJson(todo),
				headers : {
					'Content-Type' : 'application/json'
				}
			}).then(getUserDetails(), clearForm())
			  .success(function(data){
					$scope.todos= data
			    });
		}

		function clearForm() {
			$scope.userform.id = "";
			$scope.userform.title = "";
			$scope.userform.status = "";
			document.getElementById("id").disabled = false;
		}
		;
		function disableName() {
			document.getElementById("id").disabled = true;
		}
	});
</script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>
<body ng-app="myapp" ng-controller="myappcontroller">
	<h3>TiTle Form</h3>	
	<form ng-submit="processUserDetails()">
		<div class="table-responsive">
			<table class="table table-bordered" style="width: 800px">
				<tr>
					<td>ID</td>
					<td><input type="text" id="id" ng-model="userform.id"
						size="30" required  />
						<div ng-messages="userform.id.$error">
  <div ng-message="required">This field is required(for e.g:001AB)</div>
</div>
						</td>
				</tr>
				<tr>
					<td>Title</td>
					<td><input type="text" id="title"
						ng-model="userform.title" required size="30" />
						<div ng-messages="userform.title.$error">
  <div ng-message="required">This field is required(for e.g:education)</div>
</div>
						</td>
				</tr>				
				<tr>
					<td colspan="2"><input type="submit"
						class="btn btn-primary btn-sm" ng-click="processUser()"
						value="Create / Update User" /></td>
				</tr>
			</table>
		</div>
	</form>
	<h3>Registered Title</h3>
	<div class="table-responsive">
		<table class="table table-bordered" style="width: 800px">
			<tr>
				<th>ID</th>
				<th>Title</th>
				<th>Created Date</th>
				<th>Status</th>
				<th>Status Mark</th>
				<th>Actions</th>
			</tr>

			<tr ng-repeat="todo in todos">
				<td>{{ todo.id}}</td>
				<td>{{ todo.title }}</td>
				<td>{{todo.createdAt | date: 'yyyy-MM-dd HH:mm'}}</td>
				<td>
				<div ng-if="todo.completed === false">Pending</div>
<div ng-if="todo.completed === true">Completed</div>
				</td>
				<td>
				<div ng-if="todo.completed === false">
				<input type="checkbox" class="btn btn-primary btn-sm" ng-click="statuschange(todo)" /></div>
                 <div ng-if="todo.completed === true">
                 <input type="checkbox"  class="btn btn-primary btn-sm" ng-click="statuschange(todo)" checked="checked" /></div></td>
				</td>				
				<td><a ng-click="editUser(todo)" class="btn btn-primary btn-sm">Edit</a>
					| <a ng-click="deleteUser(todo)" class="btn btn-danger btn-sm">Delete</a>
					
					 </td>
			</tr>
		</table>
	</div>
	
</body>
</html>