# Two Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# (analyse only the relevant part - here the final line).

As a blogger
So I can write interesting stuff
I want to write posts having a title.

As a blogger
So I can write interesting stuff
I want to write posts having a content.

As a blogger
So I can let people comment on interesting stuff
I want to allow comments on my posts.

As a blogger
So I can let people comment on interesting stuff
I want the comments to have a content.

As a blogger
So I can let people comment on interesting stuff
I want the author to include their name in comments.
```

```
Nouns:

post, title, content
comment, content
commenters, name
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties              |
| --------------------- | ------------------------|
| posts                 | title, content          |
| comments              | content                 |
| commenters            | name                    |

1. Name of the first table (always plural): `posts` 

    Column names: `title`,`content`

2. Name of the second table (always plural): `comments` 

    Column names: `content`

3. Name of the third table (always plural): `commenters` 

    Column names: `name`    

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: posts
id: SERIAL
title: text
content: text

Table: comments
id: SERIAL
content: text

Table: commenters
id: SERIAL
name: text
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

posts - comments
1. Can one post have many comments? (Yes)
2. Can one comment have many posts? (No)

You'll then be able to say that:

1. **posts has many comments**
2. And on the other side, **comments belongs to posts**
3. In that case, the foreign key is in the table comments

comments - commenters
1. Can one comment have many commenters? (No)
2. Can one commenter have many comments? (Yes)

You'll then be able to say that:

1. **commenters has many comments**
2. And on the other side, **comments belongs to commenters**
3. In that case, the foreign key is in the table comments
```

## 4. Write the SQL.

```sql
-- file: students_table.sql
-- Create the table without the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text
);

CREATE TABLE commenters (
  id SERIAL PRIMARY KEY,
  name text
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  content text,
  post_id int,
  constraint fk_post foreign key(post_id) references posts(id) on delete cascade,
  commenter_id int,
  constraint fk_commenter foreign key(commenter_id) references commenters(id)
  on delete cascade
);



```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 student_directory_2 < students_table.sql
```