'use strict'


angular.module('muslink.filters', [])

.filter('groupBy', () ->
    (array, groupby=4) ->
        ###
            Groups array element by groupby elements
            ---
            res([1,2,3,4,5,6,7,8], 4) # => [[1,2,3,4], [5,6,7,8]]
        ###
        slice_num = groupby - 1
        grouped_array = []
        grouped_part = array[0..slice_num]
        while grouped_part.length
            grouped_array.push grouped_part
            array = array[groupby..]
            grouped_part = array[0..slice_num]
        grouped_array
)