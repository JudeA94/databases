
TRUNCATE TABLE posts RESTART IDENTITY;
INSERT INTO posts (title, content, views, account_id) VALUES ('hello', 'good morning', 100, 1);
INSERT INTO posts (title, content, views, account_id) VALUES ('bye', 'good night', 180, 2);