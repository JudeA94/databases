require 'account'

class AccountRepository
  def all
    sql = 'SELECT id, user_name, email_address FROM accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    all_accounts = []
    result_set.each do |record|
      account = Account.new
      account.id = record['id']
      account.user_name = record['user_name']
      account.email_address = record['email_address']
      all_accounts << account
    end
    all_accounts
  end

  def find(id)
    sql = 'SELECT id, user_name, email_address FROM accounts WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql,params)
    record = result_set[0] 
    account = Account.new
    account.id = record['id']
    account.user_name = record['user_name']
    account.email_address = record['email_address']
    account
  end

  def create(account)
    sql = 'INSERT INTO accounts (user_name, email_address) VALUES($1, $2);'
    params = [account.user_name,account.email_address]
    DatabaseConnection.exec_params(sql,params)
  end

  def update(account)
    sql = 'UPDATE accounts SET user_name = $1, email_address = $2 WHERE id = $3;'
    params = [account.user_name,account.email_address,account.id]
    DatabaseConnection.exec_params(sql,params)
  end

  def delete(id)
    sql = 'DELETE FROM accounts WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql,params)
  end
end