/*global module */

module.exports = function (grunt) {
	'use strict';

	grunt.initConfig({
		pkg : grunt.file.readJSON('package.json'),
		clean : {
			dist : [ 'build' ]
		}
	});

	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-concat');

	grunt.registerTask('build', [ 'clean' ]);
	grunt.registerTask('test', []);

	grunt.registerTask('default', [ 'build', 'test' ]);

};
