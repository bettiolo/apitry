/*global module */

module.exports = function (grunt) {
	'use strict';

	grunt.initConfig({
		pkg : grunt.file.readJSON('package.json'),
		clean : {
			dist : [ 'build' ]
		},
		concat : {
			options : {
				separator : '\n'
			},
			specs : {
				src : [ 'src/server.js' ],
				dest : 'build/server.js',
				nonull : true
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-concat');

	grunt.registerTask('build', [ 'clean', 'concat' ]);
	grunt.registerTask('test', []);

	grunt.registerTask('default', [ 'build', 'test' ]);

};
