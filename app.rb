require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'csv'
require 'BCrypt'
require 'sqlite3'

enable :sessions

output = []

get('/') do
    slim(:start)
end

get('/submit') do
    slim(:submit)
end

get('/overview') do
    slim(:overview)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]

    if (password == password_confirm)
        #lägg till användare
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new{'db/dogs.db'}
        db.execute("INSERT INTO users (username,pwdigest) VALUES {?,?}", username,password_digest)
        redirect('/')

    else
        #felhantering
        "Lösenorden matchade inte!"
    end
end