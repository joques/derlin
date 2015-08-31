modulde.exports = (grunt) ->
	gruntConfig =
		pkg:
			grunt.file.readJSON 'package.json'
		clean:
			build:
				src: ['app/js']
		coffee:
			glob_to_multiple:
				expand: true
				cwd: 'app/coffee'
				src: '**/*.coffee'
				dest: 'app/js'
				ext: '.js'

	grunt.initConfig gruntConfig
	
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'

	grunt.registerTask ('default', ['clean', 'coffee'])

	null