-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
USE OnlineBookstore;
-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table/ copy is not valid here so
-- COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
-- FROM 'E:\DATASET\Books.csv' 
-- CSV HEADER;

-- Import Data into Customers Table
-- COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
-- FROM 'E:\DATASET\Customers.csv' 
-- CSV HEADER;

-- Import Data into Orders Table
-- COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
-- FROM 'E:\DATASET\Orders.csv' 
-- CSV HEADER;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books where genre = "Fiction";

-- 2) Find books published after the year 1950:
select * from books where Published_Year > 1950;

-- 3) List all customers from the Canada:
select * from customers where country = 'canada'; 

-- 4) Show orders placed in November 2023:
select * from orders where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(stock) as Total_stocks from books;

-- 6) Find the details of the most expensive book:
select * from books
order by Price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders where Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from Orders where Total_Amount > 20;

-- 9) List all genres available in the Books table:
select distinct Genre from Books;

-- 10) Find the book with the lowest stock:
select * from books order by Stock limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_Amount) as revenue from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select * from books;
select b.Genre,sum(o.Quantity) as Total_books_sold 
from orders o
join books b on o.Book_ID=b.Book_ID
group by genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(Price) as avg_price from books
where genre='Fantasy';

-- List customers who have placed at least 2 orders:
select c.name,o.Customer_ID,count(o.Order_ID) as count_orders
from orders o
join customers c on o.Customer_ID = o.Customer_ID
group by o.Customer_ID,c.name
having COUNT(Order_id) >=2;

-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre 
select * from books
where genre = 'fantasy' 
order by price limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select b.Author, sum(o.Quantity) as Total_book_sold
from orders o
join books b on o.Book_ID=b.Book_ID
group by b.Author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:
select c.name,c.Customer_ID, sum(Total_Amount) as most_spent_orders
from orders o 
join Customers c on o.Customer_ID = c.Customer_ID
group by c.Customer_ID,c.name
order by most_spent_orders desc limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;






