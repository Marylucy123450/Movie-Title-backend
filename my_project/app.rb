# app.rb

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'bcrypt'
require 'json'


# Configure the database connection
set :database_file, 'config/database.yml'