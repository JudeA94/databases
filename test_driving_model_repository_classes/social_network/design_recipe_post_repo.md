# accounts and posts Model and Repository Classes Design Recipe


## 1. Design and create the Table

```
# (analyse only the relevant part - here the final line).

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:

user account, email address, username
posts, title, content, view count
```

Put the different nouns in this table. Replace the example with your own nouns.

| Record  | Properties                 |
| ------- | -------------------------- |
| account | username, email_address    |
| post    | title, content, views       |

Name of the table (always plural): `accounts`
Column names: `username`, `email_address`

Name of the table (always plural): `posts`
Column names: `title`, `content`, `views`

```
accounts
id: SERIAL
username: text
email_adress: text 

posts
id: SERIAL
title: text
content: text
views: int


```

CREATE TABLE accounts (
id SERIAL PRIMARY KEY,
username text,
email_address text
);

CREATE TABLE posts (
id SERIAL PRIMARY KEY,
title text,
content text
views int
);



1. Can one account have many posts? (Yes)
2. Can one post have many accounts? (No)

You'll then be able to say that:

1. **accounts has many posts**
2. And on the other side, **posts belongs to accounts**
3. In that case, the foreign key is in the table posts
```

Write the SQL.

```sql
-- file: social_network.sql
-- Create the table without the foreign key first.
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  user_name text,
  email_address text
);

-- Then the table with the foreign key.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
  account_id int,
  constraint fk_account foreign key(account_id) references accounts(id)
);

```

```

## 2. Create Test SQL seeds

```sql
-- (file: spec/seeds_accounts.sql)

TRUNCATE TABLE accounts RESTART IDENTITY;
INSERT INTO accounts (username, email_address) VALUES ('user123', 'hello@hello.co.uk');
INSERT INTO accounts (username, email_address) VALUES ('user456', 'bye@bye.co.uk');

TRUNCATE TABLE posts RESTART IDENTITY;
INSERT INTO posts (title, content, views, account_id) VALUES ('hello', 'good morning', '100', '1');
INSERT INTO posts (title, content, views, account_id) VALUES ('bye', 'good night', '180', '2');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 recipe_repository < seeds_recipes.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
  attr_accessor :id, :title, :content, :views :account_id
end
```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository

  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, account_id FROM posts;
    # Returns an array of Account objects.
  end

  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, views, account_id FROM posts WHERE id = $1;
    # Returns a single Account object.
  end

  def create(account)
    # Executes the SQL query:
    # INSERT INTO posts (title, content, views, account_id) VALUES($1, $2, $3, $4);
    # Does not return anything
  end

  def update(account)
    # Executes the SQL query:
    # UPDATE posts SET title = $1, content = $2, account_id = $3, views = $4 WHERE id = $5;
    # Does not return anything
  end

  def delete(id)
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1;
    # Does not return anything
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
###posts###
# 1
# Get all posts
repo = PostRepository.new
posts = repo.all
posts.length # =>  2
posts[0].id # =>  '1'
posts[0].title # =>  'hello'
posts[0].content # =>  'good morning'
posts[0].views # => 100
posts[0].account_id # =>  '1'
posts[1].id # =>  '2'
posts[1].title # =>  'bye'
posts[1].content # =>  'good night'
posts[1].views # => 180
posts[1].account_id # =>  '2'

# 2
# Get single post
repo = PostRepository.new
post = repo.find(1)
post.id # =>  '1'
post.title # =>  'hello'
post.content # =>  'good morning'
post.views # => 100
post.account_id # =>  '1'

# 3
# Get another single post
repo = PostRepository.new
post = repo.find(2)
post.id # =>  '2'
post.title # =>  'bye'
post.content # =>  'good night'
post.views # => 180
post.account_id # =>  '2'

# 4
# Add a new post
repo = PostRepository.new
post = Post.new
post.title = 'hola'
post.content = 'buenos dias'
post.account_id = 3
post.views = 0
repo.create(post)
all_posts = repo.all
all_posts.length # =>  3
last_post = all_posts.last
last_post.id # =>  '3'
last_post.title # =>  'hola'
last_post.content # =>  'buenos dias'
last_post.views # => 0
last_post.account_id # =>  '3' 

# 5
# Update an post
repo = PostRepository.new
post = repo.find(1)
post.title = 'adios'
post.content = 'buenas noches'
repo.update(post)
updated_post = repo.find(1)
updated_post.id # =>  '1'
updated_post.title # =>  'adios'
updated_post.content # =>  'buenas noches'
updated_post.views # => 100
last_post.account_id # =>  '1' 


# 6
# Delete an post
repo = PostRepository.new
repo.delete(1)
all_posts = repo.all
first_post = all_posts.first
all_posts.length # => 1
first_post.id # => '2'
first_post.title # => 'bye'
first_post.content # => 'good night'
first_post.views # => 180
firs_post.account_id # =>  '2' 

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# posts

# file: spec/post_repository_spec.rb
def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do
    reset_posts_table
  end

  context 'all method' do
    it 'returns all posts' do
      repo = PostRepository.new
      posts = repo.all
      expect(posts.length).to eq 2
      expect(posts[0].id).to eq 1
      expect(posts[0].title).to eq 'hello'
      expect(posts[0].content).to eq 'good morning'
      expect(posts[0].views).to eq 100
      expect(posts[0].account_id).to eq 1
      expect(posts[1].id).to eq 2
      expect(posts[1].title).to eq 'bye'
      expect(posts[1].content).to eq 'good night'
      expect(posts[1].views).to eq 180
      expect(posts[1].account_id).to eq 2
    end
  end

  context 'find method' do
    it 'returns a single post' do
      repo = PostRepository.new
      post = repo.find(1)
      expect(post.id).to eq 1
      expect(post.title).to eq 'hello'
      expect(post.content).to eq 'good morning'
      expect(post.views).to eq 100
      expect(post.account_id).to eq 1
    end
    it 'returns another singe post' do
      repo = PostRepository.new
      post = repo.find(2)
      expect(post.id).to eq 2
      expect(post.title).to eq 'bye'
      expect(post.content).to eq 'good night'
      expect(post.views).to eq 180
      expect(post.account_id).to eq 2
    end
  end

  context 'create method' do
    it 'creates apost and adds it to the database' do
      repo = PostRepository.new
      post = Post.new
      post.title = 'hola'
      post.content = 'buenos dias'
      post.views = 0
      post.account_id = '3'
      repo.create(post)
      all_posts = repo.all
      last_post = all_posts.last
      expect(all_posts.length).to eq 3
      expect(last_post.id).to eq 3
      expect(last_post.title).to eq 'hola'
      expect(last_post.content).to eq 'buenos dias'
      expect(last_post.views).to eq 0
      expect(last_post.account_id).to eq 3 
    end
  end
  
  context 'update method' do
    it 'updates a post on the the database' do
      repo = PostRepository.new
      post = repo.find(1)
      post.title = 'adios'
      post.content = 'buenas noches'
      repo.update(post)
      updated_post = repo.find(1)
      expect(updated_post.id).to eq 1
      expect(updated_post.title).to eq 'adios'
      expect(updated_post.content).to eq 'buenas noches'
      expect(updated_post.views).to eq 100
      expect(last_post.account_id).to eq 1 
    end
  end

  context 'delete method' do
    it 'deletes a post from the database' do
      repo = PostRepository.new
      repo.delete(1)
      all_posts = repo.all
      first_post = all_posts.first
      expect(all_posts.length).to eq 1
      expect(first_post.id).to eq 2
      expect(first_post.title).to eq 'bye'
      expect(first_post.content).to eq 'good night'
      expect(first_post.views).to eq 180
      expect(firs_post.account_id).to eq 2 
    end
  end
end

```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
