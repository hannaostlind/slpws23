require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'csv'
require 'BCrypt'
require 'sqlite3'

enable :sessions

output = []

get('/') do
    slim(:register)
end

get('/login') do
    slim(:login)
end

get('/submit') do
    slim(:submit)
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]

    if (password == password_confirm)
        #lägg till användare
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/hundar.db')
        db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)", username,password_digest)
        redirect('/login')

    else
        #felhantering
        "Lösenorden matchade inte!"
    end
end

post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/hundar.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first
    pwdigest = result["pwdigest"]
    id = result["id"]
    
    if BCrypt::Password.new(pwdigest) == password
        redirect('/submit')
    else
        "FEL LÖSEN!"
    end
end

get('/overview') do
    db = SQLite3::Database.new("db/hundar.db")
    db.results_as_hash = true
    @result = db.execute("SELECT * FROM Hundar")
    p @result
    slim(:"overview/index")
end

  
get('/overview/:id') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/hundar.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM hundar WHERE ID = ?",ID).first
    slim(:"overview/show",locals:{result:result})
end
