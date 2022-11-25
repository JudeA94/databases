TRUNCATE TABLE accounts RESTART IDENTITY CASCADE;
INSERT INTO accounts (user_name, email_address) VALUES ('user123', 'hello@hello.co.uk');
INSERT INTO accounts (user_name, email_address) VALUES ('user456', 'bye@bye.co.uk');