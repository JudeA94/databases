require 'recipe_repository'

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
