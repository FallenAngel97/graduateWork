;(function(){
    var xhr = new XMLHttpRequest();
    xhr.open('GET','/enumerate', false);
    xhr.send();
    if(xhr.status!=200)
        console.log(xhr.statusText);
    else
    {
        var ip_array = JSON.parse(xhr.responseText);
        ip_array.map(function(ip)
        {
            document.getElementsByTagName('aside')[0].innerHTML+="\
                <div class='singleMachine'>\
                    "+ip+"\
                </div>\
            "
        })
    }
})();
