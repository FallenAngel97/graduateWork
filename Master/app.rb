require 'sinatra/base'

class Watcher < Sinatra::Base
    get '/' do
        "Hello from sinatra"
    end
end