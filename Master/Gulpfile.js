var gulp        = require('gulp');
var browserSync = require('browser-sync').create();
var sass        = require('gulp-sass');
var uglify      = require('gulp-uglify');
var pump        = require('pump');
var sourcemaps  = require('gulp-sourcemaps');
 
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
    return gulp.src("frontend/js/*.js")
            .pipe(sourcemaps.init())
            .pipe(uglify())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest("public/js"))
            .pipe( browserSync.stream());
});

// Compile sass into CSS & auto-inject into browsers
gulp.task('sass', function() {
    return gulp.src("frontend/sass/**/*.scss")
        .pipe(sourcemaps.init())
        .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest("public/css"))
        .pipe(browserSync.stream());
});

gulp.task('production', ['uglify', 'sass']);

gulp.task('default', ['serve']);
