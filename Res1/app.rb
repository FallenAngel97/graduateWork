require 'sinatra/base'
require "sinatra/reloader"
require "active_record"
require "sinatra/activerecord"
require 'json'
require 'net/http'

require_relative 'models/singletodo'

class TodoApp < Sinatra::Base
    configure :development do
        register Sinatra::Reloader
    end

    get '/machineInfo' do
        rawData=Net::HTTP.get(URI.parse('http://localhost/server-status?auto'))
        output = %x(free)
        secondsUptime = rawData.match /ServerUptime: (.*)/
        requestsPerSecond = rawData.match /ReqPerSec: (.*)/
        linux_name = `cat /etc/*-release | grep PRETTY_NAME`
        cpu_model = `cat /proc/cpuinfo | grep "model name"`.split(":")[1]
        ["\n","(TM)","(R)", "CPU"].each { |symbol|
            cpu_model.gsub!(symbol,"") # replacing unnecessary info
        }
        machineInfo = [
            output.split(" ")[7],
            secondsUptime[1],
            linux_name.scan(/\"(.*?)\"/)[0][0],
            cpu_model[/.*(?=@)/],
            requestsPerSecond[1]
                        ]
        JSON.generate(machineInfo)
    end

    get '/reboot' do
        #need some kind of authorization here. Not sure, which one to choose
        #`sudo reboot`
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
