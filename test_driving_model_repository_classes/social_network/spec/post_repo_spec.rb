require 'post_repo'

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
      expect(posts[0].id).to eq '1'
      expect(posts[0].title).to eq 'hello'
      expect(posts[0].content).to eq 'good morning'
      expect(posts[0].views).to eq '100'
      expect(posts[0].account_id).to eq '1'
      expect(posts[1].id).to eq '2'
      expect(posts[1].title).to eq 'bye'
      expect(posts[1].content).to eq 'good night'
      expect(posts[1].views).to eq '180'
      expect(posts[1].account_id).to eq '2'
    end
  end

  context 'find method' do
    it 'returns a single post' do
      repo = PostRepository.new
      post = repo.find(1)
      expect(post.id).to eq '1'
      expect(post.title).to eq 'hello'
      expect(post.content).to eq 'good morning'
      expect(post.views).to eq '100'
      expect(post.account_id).to eq '1'
    end
    it 'returns another singe post' do
      repo = PostRepository.new
      post = repo.find(2)
      expect(post.id).to eq '2'
      expect(post.title).to eq 'bye'
      expect(post.content).to eq 'good night'
      expect(post.views).to eq '180'
      expect(post.account_id).to eq '2'
    end
  end

  context 'create method' do
    it 'creates apost and adds it to the database' do
      repo = PostRepository.new
      post = Post.new
      post.title = 'hola'
      post.content = 'buenos dias'
      post.views = '0'
      post.account_id = '2'
      repo.create(post)
      all_posts = repo.all
      last_post = all_posts.last
      expect(all_posts.length).to eq 3
      expect(last_post.id).to eq '3'
      expect(last_post.title).to eq 'hola'
      expect(last_post.content).to eq 'buenos dias'
      expect(last_post.views).to eq '0'
      expect(last_post.account_id).to eq '2'
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
      expect(updated_post.id).to eq '1'
      expect(updated_post.title).to eq 'adios'
      expect(updated_post.content).to eq 'buenas noches'
      expect(updated_post.views).to eq '100'
      expect(updated_post.account_id).to eq '1'
    end
  end

  context 'delete method' do
    it 'deletes a post from the database' do
      repo = PostRepository.new
      repo.delete(1)
      all_posts = repo.all
      first_post = all_posts.first
      expect(all_posts.length).to eq 1
      expect(first_post.id).to eq '2'
      expect(first_post.title).to eq 'bye'
      expect(first_post.content).to eq 'good night'
      expect(first_post.views).to eq '180'
      expect(first_post.account_id).to eq '2'
    end
  end
end