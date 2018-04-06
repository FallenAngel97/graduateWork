;(function(){
    var xhr = new XMLHttpRequest();
    xhr.open('GET','/enumerate', false);
    xhr.send();
    if(xhr.status!=200)
        console.log(xhr.statusText);
    else
    {
        var machine_array = JSON.parse(xhr.responseText);
        machine_array.map(function(machine)
        {
            var divider = (machine.memory/1000>999)?1000*1000:1000;
            var units = (machine.memory/1000>999)?"GB":"MB";
            document.getElementById('machinesDynamic').innerHTML+="\
                <div class='singleMachine'>\
                    <h2><a href='http://"+machine.ip+"'>"+machine.ip+"</a></h2>\
                    <h3>"+machine.linuxName+"</h3>\
                    <span>"+machine.memory/divider+" "+units+" RAM |\
                    "+machine.cpuModel+"</span>\
                </div>\
            "
        })
    }
})();
