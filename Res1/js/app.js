;(function(){
    var clock = document.getElementById('clock');
    clock.width = 200*window.devicePixelRatio;
    clock.height = 120*window.devicePixelRatio;
    clock.style.width = '200px';
    clock.style.height = '120px';
    var context = clock.getContext('2d');
    var centerX = clock.width/4;
    var centerY = clock.height/2;
    var radius = 40*window.devicePixelRatio;    
    var pressedIntoTheInput = false;
    var stopUpdating = false;
    document.getElementById('timeText').onfocus = function()
    {
        console.log("stop");
        stopUpdating = true;
    };
    document.getElementById('timeText').onkeyup = function()
    {
        stopUpdating = pressedIntoTheInput = true;
    };
    document.getElementById('timeText').onblur = function()
    {
        console.log("opened");
        if(pressedIntoTheInput!=true){
            stopUpdating = false;
            updateTime();
        }
    };
    function updateTime()
    {

        context.clearRect(0, 0, clock.width, clock.height);

        //draw watch
        context.beginPath();
        context.arc(centerX, centerY, radius, 0, 2*Math.PI, false);
        context.fillStyle='#515151';
        context.fill();;

        // draw time stamps
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

        // draw borders
        context.lineWidth='3';
        context.strokeStyle = '#d3d3d3';
        context.beginPath();
        context.moveTo(0,0);
        context.lineTo(10,0);
        context.moveTo(0,0);
        context.lineTo(0,10);
        context.moveTo(clock.width-35, clock.height); // offset by 35
        context.lineTo(clock.width-45, clock.height);
        context.moveTo(clock.width-35, clock.height);
        context.lineTo(clock.width-35, clock.height-10);
        context.stroke();

        var time = new Date();
        var minutes = time.getMinutes(),
            hours   = time.getHours();
        document.getElementById('timeText').value = hours+":"+(minutes<10?"0"+minutes:minutes);  
        context.lineWidth = '1';
        context.strokeStyle = '#e9e9e9';
        context.beginPath();
        context.moveTo(centerX, centerY);
        //Hour arrow
        context.lineTo(
            centerX+(radius-20)*Math.cos(1.5*Math.PI+2*Math.PI*hours/12),
            centerY+(radius-20)*Math.sin(1.5*Math.PI+2*Math.PI*hours/12)
        );
        context.moveTo(centerX, centerY);
        // minutes arrow
        context.lineTo(
            centerX+(radius-8)*Math.cos(1.5*Math.PI+2*Math.PI*minutes/60),
            centerY+(radius-8)*Math.sin(1.5*Math.PI+2*Math.PI*minutes/60)
        );
        context.stroke();
        if(stopUpdating!=true)
            setTimeout(updateTime, 1000);
    };
    updateTime();
})();
