-- Query examples. Run after schema.sql and seed.sql.

-- CREATE: add a new member. RETURNING displays the newly created row.
INSERT INTO users (member_number, full_name, email, phone)
VALUES ('MEM-1007', 'Test Member', 'test.member@example.com', '+90 555 010 1007')
RETURNING user_id, member_number, full_name;

-- READ: list all books, newest additions first.
SELECT book_id, title, author, total_copies, available_copies
FROM books
ORDER BY added_at DESC;

-- UPDATE: change the contact number of the member just added.
UPDATE users
SET phone = '+90 555 010 7777'
WHERE email = 'test.member@example.com'
RETURNING user_id, full_name, phone;

-- DELETE: remove the temporary member. No borrowing references this member.
DELETE FROM users
WHERE email = 'test.member@example.com'
RETURNING user_id, full_name;

-- JOIN: show borrowing details with the related member, book, and category.
SELECT br.borrowing_id, u.full_name AS member, b.title, c.name AS category,
       br.borrowed_date, br.due_date, br.returned_date, br.status
FROM borrowings AS br
JOIN users AS u ON u.user_id = br.user_id
JOIN books AS b ON b.book_id = br.book_id
JOIN categories AS c ON c.category_id = b.category_id
ORDER BY br.borrowed_date DESC, br.borrowing_id DESC
LIMIT 25;

-- GROUP BY: borrowing statistics for each member.
SELECT u.member_number, u.full_name,
       COUNT(br.borrowing_id) AS total_borrowings,
       COUNT(*) FILTER (WHERE br.status = 'BORROWED') AS currently_borrowed,
       COUNT(*) FILTER (WHERE br.status = 'OVERDUE') AS overdue_count
FROM users AS u
LEFT JOIN borrowings AS br ON br.user_id = u.user_id
GROUP BY u.user_id, u.member_number, u.full_name
ORDER BY total_borrowings DESC, u.full_name;

-- PAGINATION: page 2 when each page contains 3 books (skip the first 3 rows).
SELECT book_id, title, author
FROM books
ORDER BY title
LIMIT 3 OFFSET 3;
