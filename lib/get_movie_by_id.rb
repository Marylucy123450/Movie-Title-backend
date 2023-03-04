require 'sqlite3'

# Open a connection to the database
db = SQLite3::Database.new('movies.db')

# Prompt the user for a movie ID
print 'Enter a movie ID: '
id = gets.chomp.to_i

# Retrieve the movie with the specified ID from the database
movie = db.execute("SELECT * FROM movies WHERE id = #{id}")

# If the movie exists, print it to the console
if movie.any?
  puts "#{movie[0][0]} | #{movie[0][1]} | #{movie[0][2]} | #{movie[0][3]} | #{movie[0][4]} | #{movie[0][5]}"
else
  puts "Movie with ID #{id} not found"
end

# Close the database connection
db.close

#This code prompts the user for a movie ID, retrieves the movie with the specified ID from the movies table, and prints it to the console. If no movie with the specified ID is found, it prints a message to the console.