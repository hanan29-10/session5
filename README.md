# Library Management System (PostgreSQL)

A small, beginner-friendly database project for managing library members, books, categories, and borrowing history.

## Files

| File | Purpose |
| --- | --- |
| `schema.sql` | Creates the four related tables and constraints. |
| `seed.sql` | Inserts sample data and historical rows for index testing. |
| `queries.sql` | CRUD, JOIN, GROUP BY, and pagination examples. |
| `transactions.sql` | COMMIT and ROLLBACK demonstrations. |
| `indexes.sql` | Index creation and before/after `EXPLAIN ANALYZE`. |
| `AI_USAGE.md` | Documents the use of ChatGPT. |

## Data model

`categories` has many `books`. `users` and `books` are connected through `borrowings`: one member can borrow many books over time, and one book can appear in many borrowing records.

## Run with psql

Create a database, then run the scripts in this order:

```sql
CREATE DATABASE library_management;
```

Connect to it, then from a terminal in this folder run:

```powershell
psql -U postgres -d library_management -f schema.sql
psql -U postgres -d library_management -f seed.sql
psql -U postgres -d library_management -f queries.sql
psql -U postgres -d library_management -f transactions.sql
psql -U postgres -d library_management -f indexes.sql
```

Replace `postgres` with your PostgreSQL username if needed. You may be prompted for its password.

## Run with pgAdmin

1. Create a database named `library_management`.
2. Open **Query Tool** for that database.
3. Open each SQL file and execute it in this order: `schema.sql`, `seed.sql`, `queries.sql`, `transactions.sql`, then `indexes.sql`.
4. Read the result grid/messages after each script. In `indexes.sql`, compare the two `EXPLAIN ANALYZE` outputs.

## Verification queries

After running the schema and seed scripts, these checks should succeed:

```sql
SELECT COUNT(*) AS category_count FROM categories;
SELECT COUNT(*) AS member_count FROM users;
SELECT COUNT(*) AS book_count FROM books;
SELECT COUNT(*) AS borrowing_count FROM borrowings;
```

Expected base counts are 5 categories, 6 users, 8 books, and 12,007 borrowings. The count changes after the committed transaction because it creates one additional borrowing. `queries.sql` leaves its temporary member deleted.

## Notes on the index demonstration

`seed.sql` creates 12,000 valid historical borrowing rows so the date index has meaningful work to optimize. The first plan in `indexes.sql` is captured before the index exists. The second is captured after creation. PostgreSQL chooses a plan based on its version, table statistics, and estimated cost, but with this selective date predicate it should generally move from a sequential scan to an index-based plan.

## Local verification status

This project was not executed in the supplied workspace because no PostgreSQL `psql` client was available. The files are PostgreSQL-compatible and ready to run using the instructions above.
