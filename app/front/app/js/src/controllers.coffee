'use strict';

angular.module('muslink.controllers', ['ngRoute'])

.controller('headerController', ['$scope', '$location', ($scope, $location) ->
    $scope.isActive = (viewLocation) ->
        viewLocation == $location.path();
])

.controller('BandsCtrl', ['$scope', 'Bands', 'groupByFilter', '$timeout', ($scope, Bands, groupByFilter, $timeout) ->
    
    # Either $filter can be injected and used like $filter('filtername')(arg1,arg2)
    # or filter1Filter and use as filter1Filter(input, arg1).
    # Seccond approach is usefull for injecting single filter

    # Init
    $scope.currentPage = 1
    $scope.pageSize = 12
    $scope.order_by = 'name'
    $scope.order = 'asc'

    # $scope.bands = Bands.query((bands)->
    #     $scope.bands_collection = groupByFilter(bands, 4) # executes after promise gets resolved

    #     $scope.totalBands = bands.length
    # )
    $scope.orderBy = (evt) ->
        $scope.order_by = $(evt.target).data('value') || 'name'
        console.log $scope.order_by
        $scope.order = if ($scope.order == 'asc') then 'desc' else 'asc'
        console.log $scope.order
        $scope.pageChanged($scope.currentPage)

    # Issue get request on page change
    $scope.pageChanged = (newPageNumber) ->
        Bands.query(
            count: $scope.pageSize,
            offset: (($scope.currentPage - 1) * $scope.pageSize)
            order: $scope.order,
            order_by: $scope.order_by,
            query: $scope.q
            )

        .success((response, status, headers, config) ->
            $scope.bands = response.data.bands
            $scope.totalBands = response.data.count
            )

        Bands.genres(query: $scope.q)

        .success((response, status, headers, config) ->
            $scope.genres = response.data
            )

    # Issue get request on pageSize change (number items on the page)
    $scope.$watch('pageSize', (newValue, oldValue) ->
        return if angular.equals(newValue, oldValue)
        $scope.pageChanged($scope.currentPage)
        )

    timeoutPromise = null
    $scope.$watch('q', (newValue, oldValue) ->
        return if angular.equals(newValue, oldValue)
        $timeout.cancel(timeoutPromise)
        delayInMs = 300
        timeoutPromise = $timeout(() ->
            $scope.pageChanged($scope.currentPage)
        ,delayInMs)
        
        )

    # Issue get request on page change on First page load
    $scope.pageChanged($scope.currentPage)
])

.controller('BandCtrl', ['$scope', '$routeParams', 'Bands', '$location', ($scope, $routeParams, Bands, $location) ->
    Bands.get(id: $routeParams.id)
    .success((response, status, headers, config) ->
        $scope.band = response.data
        )

    $scope.goEdit = () ->
        $location.path($location.path()+'/edit')
])

.controller('EditBandCtrl', ['$scope', '$routeParams', 'Bands', '$location', '$timeout', ($scope, $routeParams, Bands, $location, $timeout) ->
    # Init values
    $scope.bandsProp = {}
    $scope.bandsProp.genres = []
    $scope.bandsProp.availableGenres = []
    $scope.errors = {}
    $scope.info = {}
    $scope.info.addGenre = {}
    $scope.errors.addGenre = {}
    $scope.dup = null

    Bands.get(id: $routeParams.id)
    .success((response, status, headers, config) ->
        $scope.band = response.data
        $scope.band.oldName = $scope.band.name
        $scope.bandsProp.name = $scope.band.name
        $scope.bandsProp.genres = for genre in $scope.band.genres
            genre.name
        )

    $scope.clearAddGenreErrors = () ->
        $scope.errors.addGenre.message = null
        $scope.info.addGenre.message = null

    $scope.addGenre = () ->
        new_genre = $('#new_genre')
        if (new_genre.val().length and new_genre.val() not in $scope.bandsProp.availableGenres)
            $scope.bandsProp.availableGenres.push(new_genre.val())
            $scope.info.addGenre.message = "Genre "+"'"+new_genre.val()+"'"+" was added to list."
            $scope.clearAddGenreErrors()
        else if not new_genre.val().length
            $scope.errors.addGenre.message = "Blank input is not allowed."
        else if new_genre.val() in $scope.bandsProp.availableGenres
            $scope.errors.addGenre.message = "Genre "+new_genre.val()+" already in list."

    $scope.update = (band) ->
        Bands.update(
            id: $routeParams.id,
            band: $scope.bandsProp
            )
        .success((response, status, headers, config) ->
            $location.path("/bands/"+$routeParams.name+"/"+$routeParams.id)
            )


    Bands.genres(all: true)
    .success((response, status, headers, config) ->
        $scope.bandsProp.availableGenres = for genre in response.data
            genre.name
        )

    timeoutPromise = null
    $scope.$watch('bandsProp.name', (newValue, oldValue) ->
        return if angular.equals(newValue, oldValue) or newValue == $scope.band.name
        $timeout.cancel(timeoutPromise)
        delayInMs = 1000
        timeoutPromise = $timeout(() ->
            console.log "HELLO!!!"
            Bands.isThereDup(new_name: newValue)
            .success((response, status, headers, config) ->
                $scope.dup = if not $.isEmptyObject(response.data) then response.data else null
            )
        ,delayInMs)
        
        )
])

.controller('View2Ctrl', [() ->

])