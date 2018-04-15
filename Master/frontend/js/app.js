;(function(){
    var xhr = new XMLHttpRequest();
    xhr.open('GET','/enumerate', false);
    xhr.send();
    var singlemachine = document.getElementById('dummyServer');
    var stationsPlace = document.getElementById('mainArea');
    if(xhr.status!=200)
        console.log(xhr.statusText);
    else
    {
        var machine_array = JSON.parse(xhr.responseText);
        machine_array.map(function(machine, index)
        {
            var divider = (machine.memory/1000>999)?1000*1000:1000;
            var units = (machine.memory/1000>999)?"GB":"MB";
            document.getElementById('machinesDynamic').innerHTML+="\
                <div machineid="+index+" class='singleMachine'>\
                    <h2><a target='_blank' href='http://"+machine.ip+"'>"+machine.ip+"</a></h2>\
                    <h3>"+machine.linuxName+"</h3>\
                    <span>"+machine.memory/divider+" "+units+" RAM |\
                    "+machine.cpuModel+"</span>\
                </div>\
            ";
            var tempServer = singlemachine.cloneNode(true);
            tempServer.setAttribute('machineid', index);
            tempServer.className='readyServer';
            tempServer.getElementsByClassName('ip-address')[0].innerHTML=machine.ip;
            //It looks terrible. It needs to be optimized
            if(machine.linuxName.indexOf('Arch')!==-1)
                tempServer.getElementsByClassName('badge')[0].src='/images/arch.png'
            if(machine.linuxName.indexOf('Fedora')!==-1)
                tempServer.getElementsByClassName('badge')[0].src='/images/fedora.png'

            stationsPlace.appendChild(tempServer);
        });
        [].forEach.call(document.getElementsByClassName('readyServer'), function(el){
            el.onmouseover = function()
            {
                highlightLeft(el, 'singleMachine');
            };
            el.onmouseout = function()
            {
                disableHighlight(el, 'singleMachine');
            };
        });
        [].forEach.call(document.getElementsByClassName('singleMachine'), function(el)
        {
            el.onmouseover = function()
            {
                highlightLeft(el, 'readyServer');
            };
            el.onmouseout = function()
            {
                disableHighlight(el, 'readyServer');
            };
        });
    }
    function highlightLeft(element, target)
    {
        var index = element.getAttribute('machineid');
        [].forEach.call(document.getElementsByClassName(target), function(el){
            el.style.backgroundColor=el.getAttribute('machineid')==index?(target=='readyServer'?'#ccc':'#089690'):'';
        })
    };
    function disableHighlight(element, target)
    {
        var index = element.getAttribute('machineid');
        [].forEach.call(document.getElementsByClassName(target), function(el){
            el.removeAttribute('style');
        })
    }
})();
