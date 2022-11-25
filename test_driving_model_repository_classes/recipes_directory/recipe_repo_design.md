# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

```
# (analyse only the relevant part - here the final line).

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep a list of all my recipes with their names.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep the average cooking time (in minutes) for each recipe.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to give a rating to each of the recipes (from 1 to 5).
```

```
Nouns:

recipie, name, cooking_time, rating
```

Put the different nouns in this table. Replace the example with your own nouns.

| Record  | Properties                 |
| ------- | -------------------------- |
| recipie | name, cooking_time, rating |

Name of the table (always plural): `recipes`

Column names: `name`, `cooking_time`, `rating`

```
id: SERIAL
name: text
cooking_time: int
rating int
```

CREATE TABLE recipies (
id SERIAL PRIMARY KEY,
name text,
cooking_time int
rating int
);

```

```

## 2. Create Test SQL seeds

```sql
-- (file: spec/seeds_recipes.sql)

TRUNCATE TABLE recipes RESTART IDENTITY;
INSERT INTO recipes (name, cooking_time, rating) VALUES ('Bolognese', 120, 4);
INSERT INTO recipes (name, cooking_time, rating) VALUES ('Chocolate Cake', 45, 3);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 recipe_repository < seeds_recipes.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: recipes

# Model class
# (in lib/recipe.rb)
class Recipe
end

# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: recipes

# Model class
# (in lib/recipe.rb)

class Recipes
  attr_accessor :id, :name, :cooking_time, :rating
end
```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: recipes

# Repository class
# (in lib/recipe_repository.rb)

class RecipeRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipes;
    # Returns an array of Recipe objects.
  end

  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipes WHERE id = $1;
    # Returns a single Recipe object.
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# 1
# Get all recipes

repo = RecipeRepository.new
recipies = repo.all
recipies.length # =>  2
recipies[0].id # =>  '1'
recipies[0].name # =>  'Bolognese'
recipies[0].cooking_time # =>  '120'
recipies[0].rating # => '4'
recipies[1].id # =>  '2'
recipies[1].name # =>  'Chocolate Cake'
recipies[1].cooking_time # =>  '45'
recipies[1].rating # => '3'

# 2
# Get single recipe
repo = RecipeRepository.new
recipe = repo.find(1)
recipe.id # =>  '1'
recipe.name # =>  'Bolognese'
recipe.cooking_time # =>  '120'
recipe.rating # => '4'

# 3
# Get another single recipe
repo = RecipeRepository.new
recipe = repo.find(2)
recipe.id # =>  '2'
recipe.name # =>  'Chocolate Cake'
recipe.cooking_time # =>  '45'
recipe.rating # => '3'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb
def reset_recipes_table
  seed_sql = File.read('spec/seeds_recipes.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test' })
  connection.exec(seed_sql)
end

describe RecipeRepository do
  before(:each) do
    reset_recipes_table
  end

  context 'all method' do
    it 'returns all recipes' do
      repo = RecipeRepository.new
      recipies = repo.all
      expect(recipies.length).to eq 2
      expect(recipies[0].id).to eq '1'
      expect(recipies[0].name).to eq 'Bolognese'
      expect(recipies[0].cooking_time).to eq '120'
      expect(recipies[0].rating).to eq '4'
      expect(recipies[1].id).to eq '2'
      expect(recipies[1].name).to eq 'Chocolate Cake'
      expect(recipies[1].cooking_time).to eq '45'
      expect(recipies[1].rating).to eq '3'
    end
  end

  context 'find method' do
    it 'returns a single recipe' do
      repo = RecipeRepository.new
      recipe = repo.find(1)
      expect(recipe.id).to eq '1'
      expect(recipe.name).to eq 'Bolognese'
      expect(recipe.cooking_time).to eq '120'
      expect(recipe.rating).to eq '4'
    end
    it 'returns another singe recipe' do
      repo = RecipeRepository.new
      recipe = repo.find(2)
      expect(recipe.id).to eq '2'
      expect(recipe.name).to eq 'Chocolate Cake'
      expect(recipe.cooking_time).to eq '45'
      expect(recipe.rating).to eq '3'
    end
  end
end

```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
