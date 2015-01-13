(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('muslink.controllers', ['ngRoute']).controller('headerController', [
    '$scope', '$location', function($scope, $location) {
      return $scope.isActive = function(viewLocation) {
        return viewLocation === $location.path();
      };
    }
  ]).controller('BandsCtrl', [
    '$scope', 'Bands', 'groupByFilter', '$timeout', function($scope, Bands, groupByFilter, $timeout) {
      var timeoutPromise;
      $scope.currentPage = 1;
      $scope.pageSize = 12;
      $scope.order_by = 'name';
      $scope.order = 'asc';
      $scope.orderBy = function(evt) {
        $scope.order_by = $(evt.target).data('value') || 'name';
        console.log($scope.order_by);
        $scope.order = $scope.order === 'asc' ? 'desc' : 'asc';
        console.log($scope.order);
        return $scope.pageChanged($scope.currentPage);
      };
      $scope.pageChanged = function(newPageNumber) {
        Bands.query({
          count: $scope.pageSize,
          offset: ($scope.currentPage - 1) * $scope.pageSize,
          order: $scope.order,
          order_by: $scope.order_by,
          query: $scope.q
        }).success(function(response, status, headers, config) {
          $scope.bands = response.data.bands;
          return $scope.totalBands = response.data.count;
        });
        return Bands.genres({
          query: $scope.q
        }).success(function(response, status, headers, config) {
          return $scope.genres = response.data;
        });
      };
      $scope.$watch('pageSize', function(newValue, oldValue) {
        if (angular.equals(newValue, oldValue)) {
          return;
        }
        return $scope.pageChanged($scope.currentPage);
      });
      timeoutPromise = null;
      $scope.$watch('q', function(newValue, oldValue) {
        var delayInMs;
        if (angular.equals(newValue, oldValue)) {
          return;
        }
        $timeout.cancel(timeoutPromise);
        delayInMs = 300;
        return timeoutPromise = $timeout(function() {
          return $scope.pageChanged($scope.currentPage);
        }, delayInMs);
      });
      return $scope.pageChanged($scope.currentPage);
    }
  ]).controller('BandCtrl', [
    '$scope', '$routeParams', 'Bands', '$location', function($scope, $routeParams, Bands, $location) {
      Bands.get({
        id: $routeParams.id
      }).success(function(response, status, headers, config) {
        return $scope.band = response.data;
      });
      return $scope.goEdit = function() {
        return $location.path($location.path() + '/edit');
      };
    }
  ]).controller('EditBandCtrl', [
    '$scope', '$routeParams', 'Bands', '$location', '$timeout', function($scope, $routeParams, Bands, $location, $timeout) {
      var timeoutPromise;
      $scope.bandsProp = {};
      $scope.bandsProp.genres = [];
      $scope.bandsProp.availableGenres = [];
      $scope.errors = {};
      $scope.info = {};
      $scope.info.addGenre = {};
      $scope.errors.addGenre = {};
      $scope.dup = null;
      Bands.get({
        id: $routeParams.id
      }).success(function(response, status, headers, config) {
        var genre;
        $scope.band = response.data;
        $scope.band.oldName = $scope.band.name;
        $scope.bandsProp.name = $scope.band.name;
        return $scope.bandsProp.genres = (function() {
          var _i, _len, _ref, _results;
          _ref = $scope.band.genres;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            genre = _ref[_i];
            _results.push(genre.name);
          }
          return _results;
        })();
      });
      $scope.clearAddGenreErrors = function() {
        $scope.errors.addGenre.message = null;
        return $scope.info.addGenre.message = null;
      };
      $scope.addGenre = function() {
        var new_genre, _ref, _ref1;
        new_genre = $('#new_genre');
        if (new_genre.val().length && (_ref = new_genre.val(), __indexOf.call($scope.bandsProp.availableGenres, _ref) < 0)) {
          $scope.bandsProp.availableGenres.push(new_genre.val());
          $scope.info.addGenre.message = "Genre " + "'" + new_genre.val() + "'" + " was added to list.";
          return $scope.clearAddGenreErrors();
        } else if (!new_genre.val().length) {
          return $scope.errors.addGenre.message = "Blank input is not allowed.";
        } else if (_ref1 = new_genre.val(), __indexOf.call($scope.bandsProp.availableGenres, _ref1) >= 0) {
          return $scope.errors.addGenre.message = "Genre " + new_genre.val() + " already in list.";
        }
      };
      $scope.update = function(band) {
        return Bands.update({
          id: $routeParams.id,
          band: $scope.bandsProp
        }).success(function(response, status, headers, config) {
          return $location.path("/bands/" + $routeParams.name + "/" + $routeParams.id);
        });
      };
      Bands.genres({
        all: true
      }).success(function(response, status, headers, config) {
        var genre;
        return $scope.bandsProp.availableGenres = (function() {
          var _i, _len, _ref, _results;
          _ref = response.data;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            genre = _ref[_i];
            _results.push(genre.name);
          }
          return _results;
        })();
      });
      timeoutPromise = null;
      return $scope.$watch('bandsProp.name', function(newValue, oldValue) {
        var delayInMs;
        if (angular.equals(newValue, oldValue) || newValue === $scope.band.name) {
          return;
        }
        $timeout.cancel(timeoutPromise);
        delayInMs = 1000;
        return timeoutPromise = $timeout(function() {
          console.log("HELLO!!!");
          return Bands.isThereDup({
            new_name: newValue
          }).success(function(response, status, headers, config) {
            return $scope.dup = !$.isEmptyObject(response.data) ? response.data : null;
          });
        }, delayInMs);
      });
    }
  ]).controller('View2Ctrl', [function() {}]);

}).call(this);
