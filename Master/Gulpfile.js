var gulp        = require('gulp');
var browserSync = require('browser-sync').create();
var sass        = require('gulp-sass');
var uglify      = require('gulp-uglify');
var pump        = require('pump');

gulp.task('serve', ['sass', 'uglify'], function() {
    browserSync.init({
        proxy:"http://192.168.50.4/",
        open: false
    });

    gulp.watch("frontend/js/*.js", ['uglify']);
    gulp.watch("frontend/sass/**/*.scss", ['sass']);
    gulp.watch("views/*.erb").on('change', browserSync.reload);
});

gulp.task('uglify', function(cb)
{
    pump([
        gulp.src("frontend/js/*.js"),
        uglify(),
        gulp.dest("public/js"),
        browserSync.stream()
    ], cb);
});

// Compile sass into CSS & auto-inject into browsers
gulp.task('sass', function() {
    return gulp.src("frontend/sass/**/*.scss")
        .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
        .pipe(gulp.dest("public/css"))
        .pipe(browserSync.stream());
});

gulp.task('production', ['uglify', 'sass']);

gulp.task('default', ['serve']);