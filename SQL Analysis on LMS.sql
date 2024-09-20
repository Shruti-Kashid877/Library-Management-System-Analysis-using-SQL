create database lms;
use lms;

# 1) Creating tables
# 2) Inserting Records
create table Books (
BookID int primary key, Title varchar(255), Author varchar(255), PublicationYear year, Genre varchar(100));
insert into books values(1,"Rules of Life", "Jordan Peterson", 2018,"Psycology"),
(2,"Atomic Habits","James Clear",2018,"Psycology"),
(3,"Zero To One","Peter Thiel",2014,"Business"),
(4,"Think and Grow Rich","Napoleon Hill",1937,"Business"),
(5,"Mindset","Carol Dweck",2006,"Business"),
(6,"The Evil Under Sun","Agatha Christie",1941,"Thriller"),
(7,"The Guest List","Lucy Foley",2020,"Thriler"),
(8,"Towards Zero","Agatha Christie",1944,"Thriller"),
(9,"Beloved","Toni Morrison",1987,"Fiction"),
(10,"War and Peace","Leo Tolstoy",1967,"Fiction"),
(11,"Science and technology","Neeraj Nachiketa",1982,"Science");
select * from Books;


create table Members (
MemberID int primary key, FirstName varchar(50), LastName varchar(50), Email varchar(100), MembershipDate date);
insert into Members values (1, "Shruti", "Kashid", "shruti.kashid@example.com", "2022-01-15"),
(2, "Avii", "Pawar", "avii.pawar@example.com", "2023-03-22"),
(3, "Riddhi", "Vaidya", "riddhi.vaidya@example.com", "2021-07-19"),
(4, "Tanu", "Bharadwaj", "tanu.bharadwaj@example.com", "2020-11-30"),
(5, "Jaya", "Shetty", "jaya.shetty@example.com", "2022-08-10"),
(6, "Sanika", "Mate", "sanika.mate@example.com", "2021-05-17"),
(7, "Vaibhav", "Jadhav", "vaibhav.jadhav@example.com", "2023-02-28"),
(8, "Rohit", "Gurav", "rohit.gurav@example.com", "2019-12-25"),
(9, "Aryan", "Singh", "aryan.singh@example.com", "2023-06-15"),
(10, "Rinit", "Jain", "rinit.jain@example.com", "2021-09-05");

select * from members;

create table Loans (
LoanID int primary key, BookID int, MemberID int, LoanDate date, ReturnDate date, 
foreign key (BookID) references Books(BookID), foreign key (MemberID) references Members(MemberID));
insert into Loans values (1, 3, 1, "2024-01-10", null),  
(2, 4, 1, "2024-02-20", "2024-03-01"),  
(3, 5, 1, "2024-03-15", null),  
(4, 6, 1, "2024-04-25", "2024-05-10"), 
(5, 8, 1, "2024-06-05", "2024-06-20"),
(6, 4, 2, "2024-01-25", "2024-02-27"), 
(7, 10, 2, "2024-03-10", "2024-03-25"),  
(8, 4, 3, "2024-04-15", "2024-08-02"), 
(9, 2, 4, "2024-06-01", "2024-06-15"),
(10, 4, 5, "2024-08-05", "2024-08-20"),
(11, 3, 3, "2024-01-25", "2024-02-27"), 
(12, 10, 5, "2024-03-10", "2024-03-25"),  
(13, 3, 3, "2024-04-15", "2024-08-02"),
(14, 4, 1, "2024-01-25", "2024-02-27");
select * from loans;

create table Authors(
AuthorID int primary key, Authorname varchar(50), Birthyear year);
insert into Authors values(1, 'Toni Morrison', 1931),
(2, 'Peter Thiel', 1967),
(3, 'J.K. Rowling', 1965),
(4, 'Jordan Peterson', 1962),
(5, 'Leo Tolstoy', 1928),
(6, 'James Clear', 1986),
(7, 'Napoleon Hill', 1983),
(8, 'Lucy Foley', 1986),
(9, 'Agatha Christie', 1990),
(10, 'Carol Dweck', 1946);
select * from authors;

create table Bookauthors(
BookID int, AuthorID int, foreign key(BookID) references Books(BookID), foreign key(AuthorID) references Authors(AuthorID));
insert into BookAuthors values (1, 4), (2, 6), (3, 2),(4, 7),(5, 10),(6, 9),  (7, 8), (8, 9),(9, 1), (10, 5); 
select * from BookAuthors;


create table Fines(
FineID int primary key, LoanID int,FineAmount dec(8,2), PaidDate date, foreign key(LoanID) references Loans(LoanID));
insert into Fines values
(1, 2, 5, '2023-03-10'),
(2, 4, 9, '2023-04-30'),
(3, 6, 20, '2023-07-10'), 
(4, 7, 15, '2023-08-01'),  
(5, 9, 50, '2023-09-30');
select * from Fines;

# Questions 
# 3) Select Records:  Write a query to select all books published before 2000 from the Books table.
select * from Books where PublicationYear < 2000;

# 4) Where Clause (AND/OR): Write a query to select all Loans where the LoanDate is in 2024 and the ReturnDate is NULL.
select * 
from loans
where year(loanDate) = 2024  and returndate is null;

#5) LIKE Operator:Write a query to select all Books where the Title contains 'Science'.
select * 
from books
where title like '%science%';

# 6)CASE Statement: Write a query to select Title and a new column Availability from the Books table. 
# If a book has been loaned out (i.e., exists in Loans table with a NULL ReturnDate), set Availability to 'Checked Out', 
# otherwise 'Available'.

select title, 
case 
when returndate is null then 'checked out'
else 'available'
end "availability"
from books left outer join loans using(bookID);

# 7) Subquery: Write a query to find all Members who have borrowed more than 5 books. 
# Use a subquery to find these MemberIDs.
select * from members 
where memberid in ( select memberid from loans group by memberid having count(memberid) > 5);

# 8) Group By: Write a query to get the total number of books borrowed by each Member. Group the results by MemberID.
select memberid, count(loanID) "total_books"
from loans
group by memberid;

# 9) Having Clause: Write a query to get the total FineAmount collected for each LoanID, 
# but only include loans where the total fine amount is greater than $10. Use the HAVING clause.
select loanid, sum(fineamount) "total_fineamount"
from fines
group by loanid
having total_fineamount > 10;

# 10) limit: Write a query to select the top 5 most frequently borrowed books.
select title, count(LoanID)"counts"
from loans join books using(bookID)
group by title
order by counts desc
limit 5;

# 11) Inner Join: Write a query to join Loans with Books to get a list of all loans with Title, LoanDate, and ReturnDate.
select title, loandate, returndate
from loans inner join books using(bookid);

# 12) Outer Join: Write a query to get a list of all Books and any associated loans. 
# Include books that might not be currently borrowed.
select title, loandate, returndate
from books left outer join loans using(bookid);

# 13)Join with Aggregation: Write a query to get the total number of books each Author has written. 
# Use an INNER JOIN between Books and BookAuthors, and group by AuthorID.
select authorid, authorname, count(bookid) "count"
from authors inner join bookauthors using(authorid) group by authorid;

# 14) Subquery with Join: Write a query to find all Books that were written by authors born after 1970. 
# Use a subquery in the WHERE clause to find these AuthorIDs.
select * from books where bookid in (select bookid from bookauthors inner join authors using(authorid) where birthyear > 1970);

# 15) Advanced Join: Write a query to list Title, AuthorName, and FineAmount for all books where a fine has been recorded. 
# Use INNER JOIN and LEFT JOIN as necessary to get all required details.
select b.Title, a.AuthorName, f.FineAmount
from Fines f inner join Loans l using(LoanID) inner join Books b using(BookID) 
inner join BookAuthors ba using(BookID) inner join Authors a using(AuthorID);
