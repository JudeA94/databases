# Updating and deleting data

_**This is a Makers Bite.** Bites are designed to train specific skills or
tools. They contain an intro, a demonstration video, some exercises with an
example solution video, and a challenge without a solution video for you to test
your learning. [Read more about how to use Makers
Bites.](https://github.com/makersacademy/course/blob/main/labels/bites.md)_

Learn to write `UPDATE` and `DELETE` SQL queries.

## Introduction

In this section you'll learn about two other type of SQL queries, `UPDATE` and `DELETE` which, as their name implies, are used to update and delete records.

## Updating records

The general syntax of the `UPDATE` query is:

```sql
UPDATE [table name] SET [column_name] = [new_value];
```

And here's an example:

```sql
UPDATE albums SET title = 'A new title';
```

However this would update the `title` for **all records**, which is usually not what we want. 

As for `SELECT` queries, we can use `WHERE` to specify which records to update. 

```sql
UPDATE [table name] SET [column_name] = [new_value], [other_column_name] = [other_new_value];
```

### Updating specific records

We can also use the `WHERE` keyword to specify conditions, like for `SELECT` queries. Only records matching these conditions will be updated.

```sql
UPDATE [table name] SET [column_name] = [new_value]
  WHERE [conditions];
```

## Deleting records

The `DELETE` query has a slightly different syntax, but works in a similar fashion.

Make sure you **always** specify conditions when using `DELETE` (unless you have good reasons not to), to avoid deleting the entire table.

```sql
DELETE FROM [table name] WHERE [conditions];

-- Or, delete all records (never do this!)
DELETE FROM [table name];
```

## Demonstration

[Here's a video demonstration.](https://www.youtube.com/watch?v=9wT1FVQbPZw&t=1710s) Make sure you attempt the exercise before watching the solution.

## Exercise

Update the `release_year` of the album with ID `3` to the value `1972`.

Use a `SELECT` query to get that specific record and verify it has been updated.

[Solution video](https://www.youtube.com/watch?v=9wT1FVQbPZw&t=2115s)

## Challenge

Delete the album with ID `12`.

Use a `SELECT` query to get the list of albums and verify that one has been deleted.

[Next Challenge](05_creating_new_data.md)

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=sql_bites%2F04_updating_and_deleting_date.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=sql_bites%2F04_updating_and_deleting_date.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=sql_bites%2F04_updating_and_deleting_date.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=sql_bites%2F04_updating_and_deleting_date.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=sql_bites%2F04_updating_and_deleting_date.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->
