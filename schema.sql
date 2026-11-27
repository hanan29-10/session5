-- Library Management System: database schema (PostgreSQL)
-- Run this file first. It recreates the project tables for a clean start.

DROP TABLE IF EXISTS borrowings;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_number VARCHAR(12) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(25),
    joined_on DATE NOT NULL DEFAULT CURRENT_DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT users_member_number_format CHECK (member_number ~ '^MEM-[0-9]{4,8}$'),
    CONSTRAINT users_email_format CHECK (email LIKE '%@%.%')
);

CREATE TABLE books (
    book_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
    title VARCHAR(250) NOT NULL,
    author VARCHAR(150) NOT NULL,
    isbn CHAR(13) NOT NULL UNIQUE,
    published_year SMALLINT,
    total_copies INTEGER NOT NULL DEFAULT 1,
    available_copies INTEGER NOT NULL DEFAULT 1,
    added_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT books_published_year_valid CHECK (published_year BETWEEN 1000 AND 2100),
    CONSTRAINT books_total_copies_positive CHECK (total_copies > 0),
    CONSTRAINT books_available_copies_valid CHECK (available_copies BETWEEN 0 AND total_copies),
    CONSTRAINT books_isbn_digits CHECK (isbn ~ '^[0-9]{13}$')
);

CREATE TABLE borrowings (
    borrowing_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    book_id INTEGER NOT NULL REFERENCES books(book_id) ON DELETE RESTRICT,
    borrowed_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    returned_date DATE,
    status VARCHAR(10) NOT NULL DEFAULT 'BORROWED',
    notes TEXT,
    CONSTRAINT borrowings_dates_valid CHECK (due_date >= borrowed_date),
    CONSTRAINT borrowings_return_date_valid CHECK (returned_date IS NULL OR returned_date >= borrowed_date),
    CONSTRAINT borrowings_status_valid CHECK (status IN ('BORROWED', 'RETURNED', 'OVERDUE'))
);

-- A book can be in one category; a category can contain many books.
-- A user and a book can each appear in many borrowing records.
