(function() {
  'use strict';
  angular.module('muslink.filters', []).filter('groupBy', function() {
    return function(array, groupby) {
      var grouped_array, grouped_part, slice_num;
      if (groupby == null) {
        groupby = 4;
      }

      /*
          Groups array element by groupby elements
          ---
          res([1,2,3,4,5,6,7,8], 4) # => [[1,2,3,4], [5,6,7,8]]
       */
      slice_num = groupby - 1;
      grouped_array = [];
      grouped_part = array.slice(0, +slice_num + 1 || 9e9);
      while (grouped_part.length) {
        grouped_array.push(grouped_part);
        array = array.slice(groupby);
        grouped_part = array.slice(0, +slice_num + 1 || 9e9);
      }
      return grouped_array;
    };
  });

}).call(this);
