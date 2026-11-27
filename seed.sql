-- Sample data for the Library Management System.
-- Run after schema.sql. The final INSERT adds history for the index example.

INSERT INTO categories (name, description) VALUES
('Fiction', 'Novels and short stories'),
('Science', 'Popular science and scientific reference'),
('Technology', 'Programming and computing books'),
('History', 'Books about historical events and people'),
('Children', 'Books for young readers');

INSERT INTO users (member_number, full_name, email, phone, joined_on) VALUES
('MEM-1001', 'Aylin Demir', 'aylin.demir@example.com', '+90 555 010 1001', '2024-01-15'),
('MEM-1002', 'Mehmet Kaya', 'mehmet.kaya@example.com', '+90 555 010 1002', '2024-02-10'),
('MEM-1003', 'Zeynep Arslan', 'zeynep.arslan@example.com', '+90 555 010 1003', '2024-03-05'),
('MEM-1004', 'Can Yilmaz', 'can.yilmaz@example.com', '+90 555 010 1004', '2024-04-21'),
('MEM-1005', 'Elif Sahin', 'elif.sahin@example.com', '+90 555 010 1005', '2024-05-12'),
('MEM-1006', 'Deniz Aydin', 'deniz.aydin@example.com', '+90 555 010 1006', '2024-06-18');

INSERT INTO books (category_id, title, author, isbn, published_year, total_copies, available_copies) VALUES
((SELECT category_id FROM categories WHERE name = 'Fiction'), 'The Midnight Library', 'Matt Haig', '9780525559498', 2020, 4, 4),
((SELECT category_id FROM categories WHERE name = 'Science'), 'A Brief History of Time', 'Stephen Hawking', '9780553380163', 1998, 3, 3),
((SELECT category_id FROM categories WHERE name = 'Technology'), 'Clean Code', 'Robert C. Martin', '9780132350884', 2008, 5, 3),
((SELECT category_id FROM categories WHERE name = 'Technology'), 'PostgreSQL: Up and Running', 'Regina Obe', '9781491963418', 2017, 2, 1),
((SELECT category_id FROM categories WHERE name = 'History'), 'Sapiens', 'Yuval Noah Harari', '9780062316097', 2015, 4, 4),
((SELECT category_id FROM categories WHERE name = 'Children'), 'Matilda', 'Roald Dahl', '9780142410370', 2007, 3, 3),
((SELECT category_id FROM categories WHERE name = 'Fiction'), 'Klara and the Sun', 'Kazuo Ishiguro', '9780593318171', 2021, 2, 2),
((SELECT category_id FROM categories WHERE name = 'Science'), 'The Gene', 'Siddhartha Mukherjee', '9781476733524', 2016, 2, 2);

INSERT INTO borrowings (user_id, book_id, borrowed_date, due_date, returned_date, status, notes) VALUES
(1, 1, '2026-10-02', '2026-10-16', '2026-10-12', 'RETURNED', 'Returned in good condition'),
(2, 3, '2026-11-08', '2026-11-22', NULL, 'OVERDUE', 'Reminder sent'),
(3, 4, '2026-11-18', '2026-12-02', NULL, 'BORROWED', NULL),
(4, 6, '2026-10-25', '2026-11-08', '2026-11-05', 'RETURNED', NULL),
(5, 3, '2026-11-20', '2026-12-04', NULL, 'BORROWED', NULL),
(1, 2, '2026-09-01', '2026-09-15', '2026-09-14', 'RETURNED', NULL),
(6, 5, '2026-10-10', '2026-10-24', '2026-10-23', 'RETURNED', NULL);

-- 12,000 additional historical rows make the index comparison meaningful.
-- Each row references an existing member and book and has a valid returned date.
INSERT INTO borrowings (user_id, book_id, borrowed_date, due_date, returned_date, status, notes)
SELECT
    ((n - 1) % 6) + 1,
    ((n - 1) % 8) + 1,
    CURRENT_DATE - ((n - 1) % 730),
    CURRENT_DATE - ((n - 1) % 730) + 14,
    CURRENT_DATE - ((n - 1) % 730) + 7,
    'RETURNED',
    'Generated historical record for index demonstration'
FROM generate_series(1, 12000) AS n;

ANALYZE borrowings;
