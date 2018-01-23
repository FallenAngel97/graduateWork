var gulp        = require('gulp');
var browserSync = require('browser-sync').create();
var sass        = require('gulp-sass');

gulp.task('serve', ['sass'], function() {
    
        browserSync.init({
            proxy:"http://192.168.50.20/",
            open: false
        });
    
        gulp.watch("styles/*.scss", ['sass']);
        gulp.watch("views/*.erb").on('change', browserSync.reload);
    });
    
    // Compile sass into CSS & auto-inject into browsers
    gulp.task('sass', function() {
        return gulp.src("styles/*.scss")
            .pipe(sass().on('error', sass.logError))
            .pipe(gulp.dest("public/css"))
            .pipe(browserSync.stream());
    });
    
gulp.task('default', ['serve']);
