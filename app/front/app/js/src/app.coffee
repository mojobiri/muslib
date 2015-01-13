'use strict';

# Declare app level module which depends on views, and components
angular.module('muslink', [
  'ngRoute',
  'ngResource',
  'ui.bootstrap',
  "ui.select",
  'muslink.controllers',
  'muslink.services',
  'muslink.directives',
  'muslink.filters',
  'angularUtils.directives.dirPagination'  
  'muslink.version'
])
.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/bands',           templateUrl: 'templates/bands.html',  controller: 'BandsCtrl');
  $routeProvider.when('/bands/:name/:id', templateUrl: 'templates/band.html',   controller: 'BandCtrl' );
  $routeProvider.when('/bands/:name/:id/edit', templateUrl: 'templates/edit_band.html',   controller: 'EditBandCtrl' );
  $routeProvider.when('/view2',           templateUrl: 'templates/view2.html',  controller: 'View2Ctrl');
  $routeProvider.otherwise(redirectTo: '/bands');
])
.config((uiSelectConfig) ->
  uiSelectConfig.theme = 'bootstrap'
)