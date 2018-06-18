require 'json'

class MyApp
    def call(env)
        output = %x(free)
        secondsUptime = Time.now - IO.read('/proc/uptime').split[0].to_f
        linux_name = `cat /etc/*-release | grep PRETTY_NAME`
        cpu_model = `cat /proc/cpuinfo | grep "model name"`.split(":")[1]
        ["\n","(TM)","(R)", "CPU"].each { |symbol|
            cpu_model.gsub!(symbol,"") # replacing unnecessary info
        }
        machine_id =  `sudo cat /sys/class/dmi/id/product_uuid`
        machineInfo = [
            output.split(" ")[7],
            secondsUptime,
            linux_name.scan(/\"(.*?)\"/)[0][0],
            cpu_model[/.*(?=@)/],
            machine_id
                        ]
        [200, {"Content-Type" => "text/html"}, [JSON.generate(machineInfo)]]
    end
end