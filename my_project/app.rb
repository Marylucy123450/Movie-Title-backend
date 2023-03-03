# app.rb

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'bcrypt'
require 'json'



# Configure the database connection
set :database_file, 'config/database.yml'

# Define the user and movie models
class User < ActiveRecord::Base
  has_many :movies
  validates :email, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :name, presence: true
end

class Movie < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
end

# Define the routes

# Register a new user
post '/users' do
  data = JSON.parse(request.body.read)
  user = User.new(
    name: data['name'],
    email: data['email'],
    password_hash: BCrypt::Password.create(data['password'])
  )
  if user.save
    status 201
    { message: 'User created successfully' }.to_json
  else
    status 400
    { message: user.errors.full_messages.join(', ') }.to_json
  end
end

# Login a user
post '/login' do
  data = JSON.parse(request.body.read)
  user = User.find_by(email: data['email'])
  if user && BCrypt::Password.new(user.password_hash) == data['password']
    session[:user_id] = user.id
    { message: 'Login successful' }.to_json
  else
    status 401
    { message: 'Invalid email or password' }.to_json
  end
end

# Logout a user
delete '/logout' do
  session.clear
  { message: 'Logged out successfully' }.to_json
end

# Add a new movie
post '/movies' do
  data = JSON.parse(request.body.read)
  user = User.find(session[:user_id])
  movie = user.movies.new(title: data['title'], year: data['year'])
  if movie.save
    status 201
    { message: 'Movie added successfully' }.to_json
  else
    status 400
    { message: movie.errors.full_messages.join(', ') }.to_json
  end
end

# View all movies added by the current user
get '/movies' do
  user = User.find(session[:user_id])
  movies = user.movies.all
  movies.to_json
end

# View all available movies
get '/movies/all' do
  movies = Movie.all
  movies.to_json
end

# Search for a movie by title or year
get '/movies/search' do
  query = params[:q]
  movies = Movie.where('title LIKE ? OR year LIKE ?', "%#{query}%", "%#{query}%")
  movies.to_json
end

# Update details of a movie added by the current user
put '/movies/:id' do |id|
  movie = Movie.find(id)
  if movie.user_id == session[:user_id]
    data = JSON.parse(request.body.read)
    if movie.update(data)
      { message: 'Movie updated successfully' }.to_json
    else
      status 400
      { message: movie.errors.full_messages.join(', ') }.to_json
    end
  else
    status 401
    { message: 'You are not authorized to update this movie' }.to_json
  end
end

# Remove a movie added by the current user
delete '/movies