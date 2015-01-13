(function() {
  'use strict';
  angular.module('muslink.services', []).factory('Bands', [
    '$resource', '$http', function($resource, $http) {
      return {
        query: function(query) {
          if (query == null) {
            query = {};
          }
          return $http({
            method: 'GET',
            url: '/api/v1/bands',
            params: query
          });
        },
        get: function(query) {
          if (query == null) {
            query = {};
          }
          return $http({
            method: 'GET',
            url: '/api/v1/bands/' + query.id,
            params: query
          });
        },
        update: function(query) {
          if (query == null) {
            query = {};
          }
          return $http({
            method: 'PUT',
            url: '/api/v1/bands/' + query.id,
            data: query
          });
        },
        genres: function(query) {
          if (query == null) {
            query = {};
          }
          return $http({
            method: 'GET',
            url: '/api/v1/genres',
            params: query
          });
        },
        isThereDup: function(query) {
          if (query == null) {
            query = {};
          }
          return $http({
            method: 'GET',
            url: '/api/v1/bands/dup',
            params: query
          });
        }
      };
    }
  ]);

}).call(this);
