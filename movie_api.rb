require 'sinatra'
require 'sqlite3'
require 'json'

# GET /movies
get '/movies' do
    # Open a connection to the database
    db = SQLite3::Database.new('movies.db')
  
    # Retrieve all movies from the database
    movies = db.execute('SELECT * FROM movies')
  
    # Convert the movies to a JSON array and return it
    movies.to_json
  end
  
  # GET /movies/:id
  get '/movies/:id' do
    # Open a connection to the database
    db = SQLite3::Database.new('movies.db')
  
    # Retrieve the movie with the specified ID from the database
    movie = db.execute("SELECT * FROM movies WHERE id = #{params['id']}")
  
    # If the movie exists, convert it to a JSON object and return it
    if movie.any?
      movie.first.to_json
    else
      # If the movie doesn't exist, return a 404 error
      halt 404, { message: 'Movie not found' }.to_json
    end
  end
  
  # POST /movies
  post '/movies' do
    # Open a connection to the database
    db = SQLite3::Database.new('movies.db')
  
    # Parse the JSON request body and extract the movie details
    data = JSON.parse(request.body.read)
    title = data['title']
    year = data['year']
    genre = data['genre']
    director = data['director']
    imdb_rating = data['imdb_rating']
  
    # Insert the movie into the database
    db.execute("INSERT INTO movies (title, year, genre, director, imdb_rating) VALUES ('#{title}', #{year}, '#{genre}', '#{director}', #{imdb_rating})")
  
    # Return a 201 status code and the new movie object as JSON
    status 201
    { message: 'Movie saved', movie: { id: db.last_insert_row_id, title: title, year: year, genre: genre, director: director, imdb_rating: imdb_rating } }.to_json
  end
  
  # PUT /movies/:id
  put '/movies/:id' do
    # Open a connection to the database
    db = SQLite3::Database.new('movies.db')
  
    # Retrieve the movie with the specified ID from the database
    movie = db.execute("SELECT * FROM movies WHERE id = #{params['id']}")
  
    # If the movie doesn't exist, return a 404 error
    halt 404, { message: 'Movie not found' }.to_json unless movie.any?
  
    # Parse the JSON request body and extract the movie details
    data = JSON.parse(request.body.read)
    title = data['title']
    year = data['year']
    genre = data['genre']
    director = data['director']
    imdb_rating = data['imdb_rating']
  
    # Update the movie in the database
    db.execute("UPDATE movies SET title = '#{title}', year = #{year}, genre = '#{genre}', director = '#{director}', imdb_rating = #{imdb_rating} WHERE id = #{params['id']}")

    # Return a 200 status code and the updated movie object as JSON
    status 200
    { message: 'Movie updated', movie: { id: params['id'], title: title, year: year, genre: genre, director: director, imdb_rating: imdb_rating } }.to_json
  end