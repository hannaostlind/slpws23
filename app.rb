require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'csv'

enable :sessions

output = []

get('/start') do

    slim(:start)
end