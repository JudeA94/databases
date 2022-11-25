require_relative 'lib/database_connection'
require_relative 'lib/recipe_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('recipes_directory')

# Perform a SQL query on the database and get the result set.
repo = RecipeRepository.new
recipes = repo.all
recipes.each do |record|
  puts "#{record.id}. #{record.name} #{record.cooking_time}mins #{record.rating}/5 "
end

recipe1 = repo.find(1)
puts "recipe 1"
puts "#{recipe1.id}. #{recipe1.name} #{recipe1.cooking_time}mins #{recipe1.rating}/5"