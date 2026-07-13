-- Create Books Table.
CREATE TABLE BOOKS (
	BOOK_ID INT PRIMARY KEY,
	TITLE VARCHAR(100),
	AUTHOR VARCHAR(100),
	GENRE VARCHAR(50),
	PUBLISHED_YEAR INT,
	PRICE NUMERIC(10, 2),
	STOCK INT
);

SELECT
	*
FROM
	BOOKS;

-- Create Customers Table.
CREATE TABLE CUSTOMERS (
	CUSTOMER_ID INT PRIMARY KEY,
	NAME VARCHAR(100),
	EMAIL VARCHAR(100),
	PHONE VARCHAR(15),
	CITY VARCHAR(50),
	COUNTRY VARCHAR(100)
);

SELECT
	*
FROM
	CUSTOMERS;

-- Create Orders Table.
CREATE TABLE ORDERS (
	ORDER_ID INT PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID INT REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);

SELECT
	*
FROM
	ORDERS;

-- Import data into Books table.
COPY BOOKS (
	BOOK_ID,
	TITLE,
	AUTHOR,
	GENRE,
	PUBLISHED_YEAR,
	PRICE,
	STOCK
)
FROM
	'Books.csv' CSV HEADER;

-- Import data into customers Table.
COPY CUSTOMERS (CUSTOMER_ID, NAME, EMAIL, PHONE, CITY, COUNTRY)
FROM
	'Customers.csv' CSV HEADER;

-- Import data into Orders table.
COPY ORDERS (
	ORDER_ID,
	CUSTOMER_ID,
	BOOK_ID,
	ORDER_DATE,
	QUANTITY,
	TOTAL_AMOUNT
)
FROM
	'Orders.csv' CSV HEADER;

-- 1) Retrive all books in the "Fiction" genre.
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fiction';

-- 2) Find Books published after the year 1950.
SELECT
	*
FROM
	BOOKS
WHERE
	PUBLISHED_YEAR > 1950;

-- 3) List all customers from canada.
SELECT
	*
FROM
	CUSTOMERS
WHERE
	COUNTRY = 'Canada';

-- 4) Show order placed in November 2023.
SELECT
	*
FROM
	ORDERS
WHERE
	ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrive the total stokes of books available.
SELECT
	SUM(STOCK) AS TOTAL_STOKES
FROM
	BOOKS;

-- 6) Find the details of the most expensive books.
SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	1;

-- 7) Show all the customers who orders more than one quantity of a books.
SELECT
	*
FROM
	ORDERS
WHERE
	QUANTITY > 1;

-- 8) Retrive all orders where the total amount exceeds $20.
SELECT
	*
FROM
	ORDERS
WHERE
	TOTAL_AMOUNT > 20;

-- 9) List all genres available in the book table.
SELECT DISTINCT
	(GENRE)
FROM
	BOOKS;

-- 10) Find the book with the lowest stock.
SELECT
	*
FROM
	BOOKS
ORDER BY
	STOCK
LIMIT
	1;

-- 11) calculate the total revenue genrated from all orders.
SELECT
	SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE
FROM
	ORDERS;

-- Advance Queries
-- 1) Retrive the total number of books sold for each genre.
SELECT
	B.GENRE,
	SUM(O.QUANTITY)
FROM
	BOOKS B
	JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.GENRE;

-- 2) Find the average price of books in the fantasy genre.
SELECT
	AVG(PRICE) AS AVG_PRICE
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy';

-- 3) List customers who have plased at least 2 orders.
SELECT
	C.CUSTOMER_ID,
	C.NAME,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	C.CUSTOMER_ID
HAVING
	COUNT(O.ORDER_ID) >= 2;

-- 4) Find the most frequently orderd book.
SELECT
	B.BOOK_ID,
	B.TITLE,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN BOOKS B ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.BOOK_ID
ORDER BY
	ORDER_COUNT DESC
LIMIT
	1;

-- 5) Show the top three most expensive books of Fantasy genre.
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
ORDER BY
	PRICE DESC
LIMIT
	3;

-- 6) Retrive the total quantity of books sold by each author.
SELECT
	B.AUTHOR,
	SUM(O.QUANTITY) AS TOTAL_QUANTITY
FROM
	BOOKS B
	JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.AUTHOR;

-- 7) List the citys where customers who spent over $30 are located.

SELECT DISTINCT
	C.CITY,
	C.NAME,
	C.CUSTOMER_ID,
	O.TOTAL_AMOUNT,
	C.COUNTRY
FROM
	CUSTOMERS C
	JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE
	O.TOTAL_AMOUNT > 30;

-- 8) Find the customers who spent the most on orders.

SELECT
	C.CUSTOMER_ID,
	C.NAME,
	SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM
	CUSTOMERS C
	JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY
	C.CUSTOMER_ID,
	C.NAME
ORDER BY
	TOTAL_SPENT DESC
LIMIT
	1;

-- 9) Calculate the stoke remaining after fulfilling all orders.

SELECT
	B.BOOK_ID,
	B.TITLE,
	B.STOCK,
	COALESCE(SUM(O.QUANTITY), 0) AS ORDER_QUANTITY,
	B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_STOCK
FROM
	BOOKS B
	LEFT JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.BOOK_ID;





