require 'sinatra/base'
require "sinatra/reloader"
require 'net/http'
require 'socket'
require 'json'
require 'bundler/setup'
require 'net/ssh'

class Watcher < Sinatra::Base
    $addresses = nil

    configure :development do
        register Sinatra::Reloader
    end
    
    get '/enumerate' do
        table = `nmap -sP 192.168.50.1/24`
        $addresses = table.scan(/192\.168\.50\..*(?=\n)/)

        inner_ip = Socket.ip_address_list.find { |info|
            info.ip_address.match(/192/i)
        }.ip_address # local ip of master ( 192.168.50.4 )
        $addresses.reject! { |ip| ip == inner_ip }
        machineInfo = []
        $addresses.each{ |addr|
            # memory seconds linuxName cpuModel
            result = JSON.parse(Net::HTTP.get(URI.parse('http://'+addr+'/machineInfo')))
            machineInfo << {
                "ip"=>addr,
                "memory"=>result[0],
                "seconds"=>result[1],
                "linuxName"=>result[2],
                "cpuModel"=>result[3]
            }
        }
        machineInfo.map { |machine| Hash[machine.each_pair.to_a] }.to_json
    end

    get '/getSSH' do
        Net::SSH.start('192.168.50.30', 'ubuntu', :password => "ubuntu") do |ssh|
            output = ssh.exec!("hostname")
            return output
        end
    end

    get '/index' do
        erb :index
    end

    get '/' do
        "development sinatr"
    end

end