require 'sqlite3'

# Open a connection to the database
db = SQLite3::Database.new('movies.db')

# Retrieve all movies from the database
movies = db.execute('SELECT * FROM movies')

# Print each movie to the console
movies.each do |movie|
  puts "#{movie[0]} | #{movie[1]} | #{movie[2]} | #{movie[3]} | #{movie[4]} | #{movie[5]}"
end

# Close the database connection
db.close

#This code uses the SQLite3 gem to open a connection to the movies.db database and retrieve all movies from the movies table. It then prints each movie to the console.