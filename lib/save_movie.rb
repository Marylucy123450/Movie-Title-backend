require 'sqlite3'

# Open a connection to the database
db = SQLite3::Database.new('movies.db')

# Prompt the user for movie details
print 'Enter the movie title: '
title = gets.chomp

print 'Enter the movie year: '
year = gets.chomp.to_i

print 'Enter the movie genre: '
genre = gets.chomp

print 'Enter the movie director: '
director = gets.chomp

print 'Enter the movie IMDB rating: '
imdb_rating = gets.chomp.to_f

# Insert the movie into the database
db.execute("INSERT INTO movies (title, year, genre, director, imdb_rating) VALUES ('#{title}', #{year}, '#{genre}', '#{director}', #{imdb_rating})")

# Print a message to the console
puts 'Movie saved to database'

# Close the database connection
db.close

#This code prompts the user for movie details, inserts the movie into the movies table, and prints a message to the console.