require 'sinatra/base'
require "sinatra/reloader"
require 'net/http'
require 'json'

class Watcher < Sinatra::Base

    $addresses = nil

    configure :development do
        register Sinatra::Reloader
    end
    
    get '/enumerate' do
        table = `nmap -sP 192.168.50.1/24`
        $addresses = table.scan(/192\.168\.50\..*(?=\n)/)
        JSON.generate($addresses)
    end

    get '/' do
        erb :index
    end
end