require "sinatra"
require "slim"
require "sqlite3"
require "bcrypt"

#start on index, redirect to either loginA(while here can redirect to signupA) or loginM

enable :sessions

get("/") do
    slim(:index)
end

get('/showloginA') do
    slim(:'login/loginA')
end

get('/showloginM') do
    slim(:'login/loginM')
end

get('/showsignupA') do
    slim(:'login/signupA')
end

get('/home') do
    slim(:index)
end

#login
post('/login') do
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('db/The_Arcana.db') 
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first #check if username exists 
    pwdigest = result["pwdigest"]
    id = result["id"]
    group = params[:group]
        

    if BCrypt::Password.new(pwdigest) == password
        session[:id] = id 
        if group == "master"
            redirect('/user/master')
        else  
            redirect('/user/apprentice')
        end
    else
        "Incorrect username or password, please try again." 
    end
    
end

get('/showsignupA') do
    slim(:'login/signupA')
end

get('/user/apprentice') do
    slim(:'user/apprentice')
end

get('/user/master') do
    slim(:'user/master')
end

#signupA
post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
    group = params[:group]

    if (password == password_confirm)
        #add user
        password_digest = BCrypt::Password.create(password)
        db = SQLite3::Database.new('db/The_Arcana.db')
        db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
        if group == "master"
            redirect('/user/master')
        else  
            redirect('/user/apprentice')
        end
    else
        #felhantering
        "Password did not match!"
    end
end


        

    

get('/master') do
    slim(:'user/master')
end

get('/apprentice') do
    slim(:'user/apprentice')
end