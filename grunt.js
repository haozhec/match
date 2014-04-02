module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    watch: {
      files: ['app/**/*', 'assets/**/*'],
      tasks: ['default']
    }
  });
  grunt.loadNpmTasks("grunt-contrib");
  
  // Default task.
  grunt.registerTask('default', 'watch');
};