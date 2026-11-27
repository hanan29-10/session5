-- Index performance example. Run after schema.sql and seed.sql.
-- Seed data deliberately includes 12,000 historical records for this comparison.

-- Make this script repeatable: ensure the first plan has no date index.
DROP INDEX IF EXISTS idx_borrowings_borrowed_date;

-- Before the index, PostgreSQL will normally use a sequential scan for this selective date search.
EXPLAIN ANALYZE
SELECT borrowing_id, user_id, book_id, borrowed_date, status
FROM borrowings
WHERE borrowed_date >= CURRENT_DATE - 3
ORDER BY borrowed_date DESC;

-- This index speeds up frequent searches and sorting by borrowing date.
CREATE INDEX idx_borrowings_borrowed_date ON borrowings (borrowed_date DESC);

ANALYZE borrowings;

-- After the index, the plan should generally use an Index Scan or Bitmap Index Scan.
EXPLAIN ANALYZE
SELECT borrowing_id, user_id, book_id, borrowed_date, status
FROM borrowings
WHERE borrowed_date >= CURRENT_DATE - 3
ORDER BY borrowed_date DESC;

-- Compare the actual time, scan type, and rows examined in both output plans.
