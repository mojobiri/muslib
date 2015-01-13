'use strict'


angular.module('muslink.directives', [])

.directive('bandRating', ['Bands', (Bands) -> 
    restrict: 'AE',
    templateUrl: 'templates/rating.html',
    scope: {},
    compile: (element, attrs) ->
        pre: (scope, element, attrs, controller, transcludeFn) ->
            # console.log attrs.ngId, attrs.ngRating

            scope.rate = Number(attrs.ngRating) || 0
            scope.max = 10
            scope.isReadonly = false

            scope.hoveringOver = (value) ->
                scope.overStar = value
                scope.percent = 100 * (value / scope.max)

            scope.ratingStates = [
                {stateOn: 'glyphicon-ok-sign', stateOff: 'glyphicon-ok-circle'},
                {stateOn: 'glyphicon-star', stateOff: 'glyphicon-star-empty'},
                {stateOn: 'glyphicon-heart', stateOff: 'glyphicon-ban-circle'},
                {stateOn: 'glyphicon-heart'},
                {stateOff: 'glyphicon-off'}
            ]

        post: (scope, element, attrs, controller, transcludeFn) ->
            scope.$watch('rate', (newValue, oldValue) ->
                return if angular.equals(newValue, oldValue)

                Bands.update(
                    id: attrs.ngId,
                    rating: newValue
                )
            )
])
# .directive('bandGenres', [() ->
#     restrict: 'AE',
#     templateUrl: 'templates/genres.html',
#     #scope:
#     #    genres: '=',
#     link: (scope, element, attrs, controllers) ->
#         # console.log 'Contr', scope, controllers
#         scope.$watch('genres', (newValue, oldValue)->
#             # return if angular.equals(newValue, oldValue)
#             scope.genres = newValue
#             console.log 'In watch:', newValue
#         , true)
#         console.log "in link"
# ])