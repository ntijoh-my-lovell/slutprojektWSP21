require "sinatra"
require "slim"
require "sqlite3"
require "bcrypt"

enable :sessions

get("/") do
    slim(:loginA)
end

post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/todo2021.db') #edit this to fit new db
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first
    pwdigest = result["pwdigest"]
    id = result["id"]

    if BCrypt::Password.new(pwdigest) == password
        session[:id] = id
        redirect('/todos')
    else
        "Incorrect username or password, please try again."
    end
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]

    if (password == password_confirm)
        #add user
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/todo2021.db')
        db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
        redirect('/')
    else
        #felhantering
        "Password did not match!"
    end
end
