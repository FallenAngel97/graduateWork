require 'sinatra/base'
require "sinatra/reloader"
require "active_record"
require "sinatra/activerecord"
require 'json'

require_relative 'models/singletodo'

class TodoApp < Sinatra::Base
    configure :development do
        register Sinatra::Reloader
    end

    get '/machineInfo' do
        output = %x(free)
        output.split(" ")[7]
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
