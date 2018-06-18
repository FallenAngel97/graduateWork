require 'sinatra/base'
require "sinatra/reloader"
require "active_record"
require "sinatra/activerecord"
require 'json'

require_relative 'models/singletodo'

class TodoApp < Sinatra::Base

#mount -cit vboxsf -o vagrant /vagrant

    configure :development do
        register Sinatra::Reloader
    end

    get '/machineInfo' do
        output = %x(free)
        secondsUptime = Time.now - IO.read('/proc/uptime').split[0].to_f
        linux_name = `cat /etc/*-release | grep PRETTY_NAME`
        cpu_model = `cat /proc/cpuinfo | grep "model name"`.split(":")[1]
        ["\n","(TM)","(R)", "CPU"].each { |symbol|
            cpu_model.gsub!(symbol,"") # replacing unnecessary info
        }
        machine_id = `sudo cat /sys/class/dmi/id/product_uuid`
        machineInfo = [
            output.split(" ")[7],
            secondsUptime,
            linux_name.scan(/\"(.*?)\"/)[0][0],
            cpu_model[/.*(?=@)/],
            machine_id
                        ]
        JSON.generate(machineInfo)
    end

    post '/addTodo' do
        SingleTodo.create(
            :title=>params["notificationText"],
            :expires_date=>params["timeText"]
        );
        redirect '/'
    end

    post '/removeTodo' do
        SingleTodo.destroy(params["idTodo"])
        redirect '/'
    end

    get '/' do
        arr = []
        SingleTodo.all.each {|record|
            arr.push({
                :idTodo=>record.id,
                :title=>record.title,
                :expires_date=>record.expires_date
            })
        }
        erb :index, :locals=>{todosArray:arr}
    end
end
