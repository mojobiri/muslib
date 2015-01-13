'use strict';

angular.module('muslink.services', [])

.factory('Bands', ['$resource', '$http', ($resource, $http) ->
    {
        query: (query={}) ->
            $http(
                method: 'GET',
                url: '/api/v1/bands',
                params: query
            );

        get: (query={}) ->
            $http(
                method: 'GET',
                url: '/api/v1/bands/'+query.id,
                params: query
            );
        update: (query={}) ->
            $http(
                method: 'PUT',
                url: '/api/v1/bands/'+query.id,
                data: query
            );
        genres: (query={}) ->
            $http(
                method: 'GET',
                url: '/api/v1/genres',
                params: query
            );
        isThereDup: (query={}) ->
            $http(
                method: 'GET',
                url: '/api/v1/bands/dup',
                params: query
            )
    }
])