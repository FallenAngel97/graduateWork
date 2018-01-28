;(function(){
    console.log(window.devicePixelRatio);
    var clock = document.getElementById('clock');
    clock.width = 200*window.devicePixelRatio;
    clock.height = 137*window.devicePixelRatio;
    clock.style.width = '200px';
    clock.style.height = '137px';
    var context = clock.getContext('2d');
    var centerX = clock.width/4;
    var centerY = clock.height/2;
    var radius = 40*window.devicePixelRatio;
    context.beginPath();
    context.arc(centerX, centerY, radius, 0, 2*Math.PI, false);
    context.fillStyle='#515151';
    context.fill();;

    (function drawLine()
    {
        context.lineWidth = '2';
        context.strokeStyle = '#e9e9e9';
        context.beginPath();
        context.moveTo(centerX, centerY-radius+2*window.devicePixelRatio);
        context.lineTo(centerX, centerY-radius+10*window.devicePixelRatio);
        context.moveTo(centerX, centerY+radius-2*window.devicePixelRatio);
        context.lineTo(centerX, centerY+radius-10*window.devicePixelRatio);
        context.moveTo(centerX + radius - 2*window.devicePixelRatio, centerY);
        context.lineTo(centerX + radius - 10*window.devicePixelRatio, centerY);
        context.moveTo(centerX - radius + 2*window.devicePixelRatio, centerY);
        context.lineTo(centerX - radius + 10*window.devicePixelRatio, centerY);
        context.stroke();
    })();
})();