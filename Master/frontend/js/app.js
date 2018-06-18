;(function(){
    var singlemachine   = document.getElementById('dummyServer');
    var stationsPlace   = document.getElementById('mainArea');
    var sshBox          = document.getElementById('dummySSH');
    var sshPlace        = document.getElementById('machinesSSH');
    var reservedSymbols = 0;
    var current_ip      = "";
    var login_string    = "";
    var machine_array;
    var xhr = new XMLHttpRequest();
    xhr.open('GET','/enumerate', true);
    xhr.send();
    xhr.onreadystatechange = function()
    {
        if(xhr.status != 200 || xhr.readyState != 4)
        {
            handleErrors(xhr);
            return;
        }
        
        machine_array = JSON.parse(xhr.responseText);
        machine_array.map(function(machine, index)
        {
            var divider = (machine.memory/1000>999)?1000*1000:1000;
            var units = (machine.memory/1000>999)?"GB":"MB";
            // offlien color: #691f05
            document.getElementById('machinesDynamic').innerHTML+="\
                <div machineid="+index+" class='singleMachine'>\
                    <h2><a target='_blank' href='http://"+machine.ip+"'>"+machine.ip+"</a></h2>\
                    <h3>"+machine.linuxName+"</h3>\
                    <span>"+machine.memory/divider+" "+units+" RAM |\
                    "+machine.cpuModel+"</span>\
                </div>\
            ";
            if (typeof(Storage) !== "undefined")
            {
                var currentdate = new Date(); 
                var datetime = "From " + currentdate.getDate() + "/"
                    + (currentdate.getMonth()+1)  + "/" 
                    + currentdate.getFullYear() + " @ "  
                    + currentdate.getHours() + ":"  
                    + currentdate.getMinutes() + ":" 
                    + currentdate.getSeconds();
                var machine_saved_state = {
                    last_time: datetime,
                    id: machine.machine_id,
                    OS: machine.linuxName,
                    RAM: machine.memory/divider+" "+units,
                    CPU: machine.cpuModel,
                    ip: machine.ip
                }
                localStorage.setItem("machine"+machine.machine_id, JSON.stringify(machine_saved_state));
            }
            var tempServer = singlemachine.cloneNode(true);
            tempServer.setAttribute('machineid', index);
            tempServer.className='readyServer';
            tempServer.getElementsByClassName('ip-address')[0].innerHTML=machine.ip;
            //It looks terrible. It needs to be optimized
            if(machine.linuxName.indexOf('Arch')!==-1)
                tempServer.getElementsByClassName('badge')[0].src='/images/arch.png'
            if(machine.linuxName.indexOf('Fedora')!==-1)
                tempServer.getElementsByClassName('badge')[0].src='/images/fedora.png'
            if(machine.linuxName.indexOf('CentOS')!==-1)
                tempServer.getElementsByClassName('badge')[0].src='/images/CentOS.png'
            
            stationsPlace.appendChild(tempServer);

            var sshMachine = sshBox.cloneNode(true);
            sshMachine.setAttribute('machineid', index);
            sshMachine.className = 'sshMachine';
            sshMachine.onclick = function()
            {
                var machineIndex = this.getAttribute('machineid');
                document.getElementById('curtain').style.display='none';
                document.getElementById('terminal').style.display='block';
                document.getElementById('sshIPTerminal').innerHTML = machine_array[machineIndex].ip;
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "/connectSSH", true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function()
                {
                    if (xhr.readyState == 4 && xhr.status == 200)
                    {
                        loginString = ''+xhr.responseText.replace("\n","")+':~$ ';
                        reservedSymbols = loginString.length;
                        document.getElementsByTagName('textarea')[0].innerHTML = loginString;
                    }
                }
                current_ip = machine_array[machineIndex].ip;
                xhr.send('ip=' + encodeURIComponent(current_ip));
            }
            sshMachine.getElementsByClassName('ipAddressSSH')[0].innerHTML = machine.ip;
            sshMachine.getElementsByClassName('OS_SSH')[0].innerHTML = " | "+machine.linuxName;
            sshPlace.appendChild(sshMachine);
        });
        [].forEach.call(document.getElementsByClassName('readyServer'), function(el){
            el.onmouseover = function(event)
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
        loop1:
        for(var machineOfflineIndex = 0; machineOfflineIndex < localStorage.length; machineOfflineIndex++)
        {
            try{
                var offlineMachine = localStorage.getItem(localStorage.key(machineOfflineIndex));
                offlineMachine = JSON.parse(offlineMachine);
                machine_array.map(function(machine)
                {
                    if(machine.ip==offlineMachine.ip)
                    {
                        return loop1;
                    }
                })
                var divider = (offlineMachine.RAM/1000>999)?1000*1000:1000;
                var units = (offlineMachine.RAM/1000>999)?"GB":"MB";
                document.getElementById('machinesDynamic').innerHTML+="\
                <div machineid="+machine_array.length+" class='singleMachine offlineMachine'>\
                    <div class='afk'>OFFLINE</div>\
                    <h2><a target='_blank' href='http://"+offlineMachine.ip+"'>"+offlineMachine.ip+"</a></h2>\
                    <h3>"+offlineMachine.OS+"</h3>\
                    <span>"+offlineMachine.RAM/divider+" "+units+" RAM |\
                    "+offlineMachine.CPU+"</span>\
                </div>\
                ";
                
            }
            catch(e){
                console.log(e);
            }
        }
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
    document.getElementById('remote_connect').onclick = function()
    {
        document.getElementById('curtain').style.display='block';
        document.getElementById('terminal').style.display = 'none';
        reservedSymbols = 0;
        current_ip      = "";
        login_string    = "";
    }
    document.getElementById('closeSSH').onclick = function()
    {
        document.getElementById('curtain').style.display='none';
    }
    function escapeRegExp(str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
    }
    document.getElementsByTagName("textarea")[0].onkeydown = function(e)
    {
        var evt = e || window.event;
        if (evt) {
            var keyCode = evt.charCode || evt.keyCode;
            if(this.selectionStart<reservedSymbols)
            {
                this.selectionStart = this.value.length + 1;
            }
            if ((keyCode === 8 && this.value.length <= reservedSymbols)) {
                if (evt.preventDefault) {
                    evt.preventDefault();
                } else {
                    evt.returnValue = false;
                }
            }
            if(keyCode == 13)
            {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "/sshExecute", true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function()
                {
                    if (xhr.readyState != 4 || xhr.status != 200)
                        return;
                    document.getElementsByTagName('textarea')[0].value +=""+xhr.responseText+loginString;
                    reservedSymbols = document.getElementsByTagName('textarea')[0].value.length;
                    document.getElementsByTagName('textarea')[0].scrollTop = document.getElementsByTagName('textarea')[0].scrollHeight;
                }
                var regex = new RegExp(escapeRegExp(loginString)+"(.*)$");
                var command = document.getElementsByTagName('textarea')[0].value.match(regex);
                xhr.send('ip=' + encodeURIComponent(current_ip)+"&command="+command[command.length-1]);
            }
        }
    }
    document.getElementById('closeSshWindow').onclick = function()
    {
        document.getElementById('terminal').style.display='none';
        reservedSymbols = 0;
        current_ip      = "";
        login_string    = "";
    }
    window.addEventListener('mouseup', mouseUp, false);
    document.getElementById('moveSshWindow').addEventListener('mousedown', mouseDown, false);
    function mouseUp()
    {
        window.removeEventListener('mousemove', divMove, true);
    }
    function divMove(e){
        var div = document.getElementById('terminal');
        div.style.top = e.clientY - 90 + 'px';
        div.style.left = e.clientX - 418/2 - 30/2 - 10 + 'px';
    }
    function mouseDown(e){
        window.addEventListener('mousemove', divMove, true);
    }
    function handleErrors(xhr)
    {
        if(xhr.status>300)
            document.getElementById('mainArea').innerHTML = "<div id='errorMessage'>"+xhr.responseText+"</div>";
    }

})();
