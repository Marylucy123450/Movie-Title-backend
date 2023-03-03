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