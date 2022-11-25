require 'account_repo'

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
      expect(accounts[0].id).to eq '1'
      expect(accounts[0].user_name).to eq 'user123'
      expect(accounts[0].email_address).to eq 'hello@hello.co.uk'
      expect(accounts[1].id).to eq '2'
      expect(accounts[1].user_name).to eq 'user456'
      expect(accounts[1].email_address).to eq 'bye@bye.co.uk'
    end
  end

  context 'find method' do
    it 'returns a single account' do
      repo = AccountRepository.new
      account = repo.find(1)
      expect(account.id).to eq '1'
      expect(account.user_name).to eq 'user123'
      expect(account.email_address).to eq 'hello@hello.co.uk'
    end
    it 'returns another singe account' do
      repo = AccountRepository.new
      account = repo.find(2)
      expect(account.id).to eq '2'
      expect(account.id).to eq '2'
      expect(account.user_name).to eq 'user456'
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
      all_accounts = repo.all
      last_account = all_accounts.last
      expect(all_accounts.length).to eq 3
      expect(last_account.id).to eq '3'
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
      expect(updated_account.id).to eq '1'
      expect(updated_account.user_name).to eq 'user111'
      expect(updated_account.email_address).to eq 'hellohello@hello.co.uk'
    end
  end

  context 'delete method' do
    xit 'deletes an account from the database' do
      repo = AccountRepository.new
      repo.delete(1)
      all_accounts = repo.all
      first_account = all_accounts.first
      expect(all_accounts.length).to eq 1
      expect(first_account.id).to eq '2'
      expect(first_account.user_name).to eq 'user456'
      expect(first_account.email_address).to eq 'bye@bye.co.uk'
    end
  end
end