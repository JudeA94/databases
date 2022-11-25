require 'post'

class PostRepository
  def all
    sql = 'SELECT id, title, content, views, account_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    all_posts = []
    result_set.each do |record|
      post = Post.new
      post.id = record['id']
      post.title = record['title']
      post.content = record['content']
      post.views = record['views']
      post.account_id = record['account_id']
      all_posts << post
    end
    all_posts
  end

  def find(id)
    sql = 'SELECT id, title, content, views, account_id FROM posts WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    record = result_set[0]
    post = Post.new
    post.id = record['id']
    post.title = record['title']
    post.content = record['content']
    post.views = record['views']
    post.account_id = record['account_id']
    post
  end

  def create(account)
    sql = 'INSERT INTO posts (title, content, views, account_id) VALUES($1, $2, $3, $4);'
    params = [account.title,account.content,account.views,account.account_id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(account)
    sql = 'UPDATE posts SET title = $1, content = $2, account_id = $3, views = $4 WHERE id = $5;'
    params = [account.title,account.content,account.account_id,account.views,account.id]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end
end
