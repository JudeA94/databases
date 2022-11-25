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
| account | user_name, email_address    |
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
# Table name: accounts

# Model class
# (in lib/account.rb)
class Account
end

# Repository class
# (in lib/account_repository.rb)
class AccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: accounts

# Model class
# (in lib/account.rb)

class Account
  attr_accessor :id, :user_name, :email_address
end
```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: accounts

# Repository class
# (in lib/account_repository.rb)

class AccountRepository

  def all
    # Executes the SQL query:
    # SELECT id, user_name, email_address FROM accounts;
    # Returns an array of Account objects.
  end

  def find(id)
    # Executes the SQL query:
    # SELECT id, user_name, email_address FROM accounts WHERE id = $1;
    # Returns a single Account object.
  end

  def create(account)
    # Executes the SQL query:
    # INSERT INTO accounts (user_name, email_address) VALUES($1, $2);
    # Does not return anything
  end

  def update(account)
    # Executes the SQL query:
    # UPDATE accounts SET user_name = $1, email_address = $2 WHERE id = $3;
    # Does not return anything
  end

  def delete(id)
    # Executes the SQL query:
    # DELETE FROM accounts WHERE id = $1;
    # Does not return anything
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
###accounts###
# 1
# Get all accounts
repo = AccountRepository.new
accounts = repo.all
accounts.length # =>  2
accounts[0].id # =>  '1'
accounts[0].user_name # =>  'user123'
accounts[0].email_address # =>  'hello@hello.co.uk'
accounts[1].id # =>  '2'
accounts[1].name # =>  'user456'
accounts[1].email_address # =>  'bye@bye.co.uk'

# 2
# Get single account
repo = AccountRepository.new
account = repo.find(1)
account.id # =>  '1'
account.user_name # =>  'user123'
account.email_address # =>  'hello@hello.co.uk'

# 3
# Get another single account
repo = AccountRepository.new
account = repo.find(2)
account.id # =>  '2'
account.id # =>  '2'
account.name # =>  'user456'
account.email_address # =>  'bye@bye.co.uk'

# 4
# Add a new account
repo = AccountRepository.new
account = Account.new
account.user_name = 'user789'
account.email_address = 'hola@hola.co.uk'
repo.create(account)
all_account = repo.all
last_account = all_accounts.last
all_accounts.length # =>  3
last_account.id # =>  '3'
last_account.user_name # =>  'user789'
last_account.email_address # =>  'hola@hola.co.uk'

# 5
# Update an account
repo = AccountRepository.new
account = repo.find(1)
account.user_name = 'user111'
account.email_address = 'hellohello@hello.co.uk'
repo.update(account)
updated_account = repo.find(1)
updated_account.id # =>  '1'
updated_account.user_name # =>  'user111'
updated_account.email_address # =>  'hellohello@hello.co.uk'

# 6
# Delete an account
repo = AccountRepository.new
repo.delete(1)
all_accounts = repo.all
first_account = all_accounts.first
all_accounts.length # => 1
first_account.id # => '2'
first_account.user_name # => 'user456'
first_account.email_address # => 'bye@bye.co.uk'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# accounts

# file: spec/account_repository_spec.rb
def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe AccountRepository do
  before(:each) do
    reset_accounts_table
  end

  context 'all method' do
    it 'returns all accounts' do
      repo = AccountRepository.new
      accounts = repo.all
      expect(accounts.length).to eq 2
      expect(accounts[0].id).to eq 1
      expect(accounts[0].user_name).to eq 'user123'
      expect(accounts[0].email_address).to eq 'hello@hello.co.uk'
      expect(accounts[1].id).to eq 2
      expect(accounts[1].name).to eq 'user456'
      expect(accounts[1].email_address).to eq 'bye@bye.co.uk'
    end
  end

  context 'find method' do
    it 'returns a single account' do
      repo = AccountRepository.new
      account = repo.find(1)
      expect(account.id).to eq 1
      expect(account.user_name).to eq 'user123'
      expect(account.email_address).to eq 'hello@hello.co.uk'
    end
    it 'returns another singe account' do
      repo = AccountRepository.new
      account = repo.find(2)
      expect(account.id).to eq 2
      expect(account.id).to eq 2
      expect(account.name).to eq 'user456'
      expect(account.email_address).to eq 'bye@bye.co.uk'
    end
  end

  context 'create method' do
    it 'creates an account and adds it to the database' do
      repo = AccountRepository.new
      account = Account.new
      account.user_name = 'user789'
      account.email_address = 'hola@hola.co.uk'
      repo.create(account)
      all_account = repo.all
      last_account = all_accounts.last
      expect(all_accounts.length).to eq 3
      expect(last_account.id).to eq 3
      expect(last_account.user_name).to eq 'user789'
      expect(last_account.email_address).to eq 'hola@hola.co.uk'
    end
  end
  
  context 'update method' do
    it 'updates an account on the the database' do
      repo = AccountRepository.new
      account = repo.find(1)
      account.user_name = 'user111'
      account.email_address = 'hellohello@hello.co.uk'
      repo.update(account)
      updated_account = repo.find(1)
      expect(updated_account.id).to eq 1
      expect(updated_account.user_name).to eq 'user111'
      expect(updated_account.email_address).to eq 'hellohello@hello.co.uk'
    end
  end

  context 'delete method' do
    it 'deletes an account from the database' do
      repo = AccountRepository.new
      repo.delete(1)
      all_accounts = repo.all
      first_account = all_accounts.first
      expect(all_accounts.length).to eq  1
      expect(first_account.id).to eq 2
      expect(first_account.user_name).to eq 'user456'
      expect(first_account.email_address).to eq 'bye@bye.co.uk'
    end
  end
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
