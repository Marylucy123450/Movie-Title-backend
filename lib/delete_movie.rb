require 'sqlite3'

# Open a connection to the database
db = SQLite3::Database.new('movies.db')

# Prompt the user for a movie ID to delete
print 'Enter a movie ID to delete: '
id = gets.chomp.to_i

# Delete the movie with the specified ID from the database
result = db.execute("DELETE FROM movies WHERE id = #{id}")

# Check if a row was affected by the delete statement
if result == 0
  puts "Movie with ID #{id} not found"
else
  puts "Movie with ID #{id} deleted"
end

# Close the database connection
db.close

#This code prompts the user for a movie ID to delete, deletes the movie with the specified ID from the movies table, and prints a message to the console indicating whether the movie was successfully deleted or not.