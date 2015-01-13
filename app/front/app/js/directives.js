(function() {
  'use strict';
  angular.module('muslink.directives', []).directive('bandRating', [
    'Bands', function(Bands) {
      return {
        restrict: 'AE',
        templateUrl: 'templates/rating.html',
        scope: {},
        compile: function(element, attrs) {
          return {
            pre: function(scope, element, attrs, controller, transcludeFn) {
              scope.rate = Number(attrs.ngRating) || 0;
              scope.max = 10;
              scope.isReadonly = false;
              scope.hoveringOver = function(value) {
                scope.overStar = value;
                return scope.percent = 100 * (value / scope.max);
              };
              return scope.ratingStates = [
                {
                  stateOn: 'glyphicon-ok-sign',
                  stateOff: 'glyphicon-ok-circle'
                }, {
                  stateOn: 'glyphicon-star',
                  stateOff: 'glyphicon-star-empty'
                }, {
                  stateOn: 'glyphicon-heart',
                  stateOff: 'glyphicon-ban-circle'
                }, {
                  stateOn: 'glyphicon-heart'
                }, {
                  stateOff: 'glyphicon-off'
                }
              ];
            },
            post: function(scope, element, attrs, controller, transcludeFn) {
              return scope.$watch('rate', function(newValue, oldValue) {
                if (angular.equals(newValue, oldValue)) {
                  return;
                }
                return Bands.update({
                  id: attrs.ngId,
                  rating: newValue
                });
              });
            }
          };
        }
      };
    }
  ]);

}).call(this);
