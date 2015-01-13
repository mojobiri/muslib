(function() {
  'use strict';
  angular.module('muslink', ['ngRoute', 'ngResource', 'ui.bootstrap', "ui.select", 'muslink.controllers', 'muslink.services', 'muslink.directives', 'muslink.filters', 'angularUtils.directives.dirPagination', 'muslink.version']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/bands', {
        templateUrl: 'templates/bands.html',
        controller: 'BandsCtrl'
      });
      $routeProvider.when('/bands/:name/:id', {
        templateUrl: 'templates/band.html',
        controller: 'BandCtrl'
      });
      $routeProvider.when('/bands/:name/:id/edit', {
        templateUrl: 'templates/edit_band.html',
        controller: 'EditBandCtrl'
      });
      $routeProvider.when('/view2', {
        templateUrl: 'templates/view2.html',
        controller: 'View2Ctrl'
      });
      return $routeProvider.otherwise({
        redirectTo: '/bands'
      });
    }
  ]).config(function(uiSelectConfig) {
    return uiSelectConfig.theme = 'bootstrap';
  });

}).call(this);
