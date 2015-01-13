'use strict';

angular.module('muslink.version', [
  'muslink.version.interpolate-filter',
  'muslink.version.version-directive'
])

.value('version', '0.1');
