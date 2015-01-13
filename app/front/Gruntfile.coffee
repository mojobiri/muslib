"use strict";

module.exports = (grunt) ->
  # Do grunt-related things in here
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),
    env: process.env, # That's how we can access system env and we can inject '<%= env %>'

    coffee: 
        glob_to_multiple:
            expand: true,
            flatten: true,
            cwd: 'app/js/src',
            src: ['*.coffee'],
            dest: 'app/js',
            ext: '.js'

    watch:
        scripts:
            files: [
                'app/js/src/*.coffee'
            ],
            tasks: ['coffee:glob_to_multiple'],
            options:
                spawn: false
    )


  # Load the plugin that provides task.
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-ng-constant')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')

  # Default task(s).
  grunt.registerTask('default', ['coffee:glob_to_multiple'])