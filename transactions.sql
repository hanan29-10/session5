-- Transaction examples. Run after schema.sql and seed.sql.

-- COMMIT makes both statements permanent as one unit of work.
BEGIN;
INSERT INTO borrowings (user_id, book_id, borrowed_date, due_date, status, notes)
VALUES (1, 7, CURRENT_DATE, CURRENT_DATE + 14, 'BORROWED', 'Transaction COMMIT example');
UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 7 AND available_copies > 0;
COMMIT;
-- The borrowing and the reduced available_copies value remain saved.

-- ROLLBACK cancels every change made since BEGIN.
BEGIN;
INSERT INTO borrowings (user_id, book_id, borrowed_date, due_date, status, notes)
VALUES (2, 8, CURRENT_DATE, CURRENT_DATE + 14, 'BORROWED', 'Transaction ROLLBACK example');
UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 8 AND available_copies > 0;
ROLLBACK;
-- Neither the borrowing nor the copy-count change from this second block is saved.
