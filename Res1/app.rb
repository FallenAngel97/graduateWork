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

    get '/addTodo' do
        SingleTodo.create(:title=>"NewPost")
    end

    get '/' do
        arr = []
        SingleTodo.all.each {|record|
            arr.push({:title=>record.title})
        }
        erb :index, :locals=>{todosArray:arr}
    end
end