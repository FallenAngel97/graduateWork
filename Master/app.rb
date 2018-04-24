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

    post '/connectSSH' do
        ipAddress = params[:ip]
        case ipAddress
        when "192.168.50.30"
            user="ubuntu"
            pass="ubuntu"
        when "192.168.50.20" , "192.168.50.15"
            user="vagrant"
            pass="vagrant"
        end
        Net::SSH.start(ipAddress, user, :password => pass) do |ssh|
            output = ssh.exec!("hostname")
            return user+"@"+output
        end
    end

    post '/sshExecute' do
        ipAddress = params[:ip]
        case ipAddress
        when "192.168.50.30"
            user="ubuntu"
            pass="ubuntu"
        when "192.168.50.20", "192.168.50.15"
            user="vagrant"
            pass="vagrant"
        end
        Net::SSH.start(ipAddress, user, :password => pass) do |ssh|
            output = ssh.exec!(params[:command])
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