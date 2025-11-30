-- Creating Tables

CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100) NOT NULL,
    AUTHOR VARCHAR(100) NOT NULL,
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT CHECK (AVAILABLE_COPIES >= 0)
);


CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    PHONE_NO VARCHAR(15),
    ADDRESS VARCHAR(200),
    MEMBERSHIP_DATE DATE
);

CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE NOT NULL,
    RETURN_DATE DATE, -- Null if the book is currently borrowed
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);


DESC Books;
DESC Members;
DESC BorrowingRecords;

-- INSERTING DATA INTO THE TABLES 


INSERT INTO Books VALUES
(101, 'The Night Watchman', 'Arjun Kapoor', 'Fiction', 2022, 2),
(102, 'SQL Mastery', 'Priya Sharma', 'Tech', 2024, 1),
(103, 'Himalayan Trek', 'Vikram Singh', 'Travel', 2021, 3),
(104, 'Cosmic Echoes', 'Maya Verma', 'Sci-Fi', 2023, 0),
(105, 'Ancient Spices', 'Rahul Desai', 'Cooking', 2020, 5),
(106, 'Data Structures 101', 'Priya Sharma', 'Tech', 2025, 4),
(107, 'Mumbai Dreams', 'Arjun Kapoor', 'Fiction', 2022, 1),
(108, 'The Golden City', 'Maya Verma', 'Travel', 2023, 2);


INSERT INTO Members VALUES
(1, 'Aarav Patel', 'aarav@example.com', '9876500001', 'Pune', '2024-01-15'),
(2, 'Diya Shah', 'diya@example.com', '9876500002', 'Mumbai', '2024-05-20'),
(3, 'Rohan Das', 'rohan@example.com', '9876500003', 'Delhi', '2025-08-10'),
(4, 'Zoya Khan', 'zoya@example.com', '9876500004', 'Bangalore', '2025-09-01'),
(5, 'Kabir Singh', 'kabir@example.com', '9876500005', 'Chennai', '2024-11-11');


INSERT INTO BorrowingRecords VALUES
(1, 1, 101, '2025-10-10', NULL),
(2, 2, 102, '2025-11-20', NULL),
(3, 2, 103, '2025-11-15', '2025-11-28'),
(4, 1, 104, '2025-11-25', NULL),
(5, 3, 106, '2025-11-28', NULL),
(6, 2, 107, '2025-11-05', '2025-11-18'),
(7, 1, 101, '2025-09-01', '2025-09-15'),
(8, 4, 105, '2025-11-01', NULL),
(9, 1, 108, '2025-11-10', '2025-11-20'),
(10, 2, 104, '2025-10-01', '2025-10-15'),
(11, 4, 103, '2025-10-25', '2025-11-05');

SELECT * FROM BOOKS;
SELECT * FROM Members;
SELECT * FROM BorrowingRecords;


-- Information Retrieval:

SELECT                                            
    M.NAME,
    B.TITLE,
    BR.BORROW_DATE
FROM
    BorrowingRecords BR
INNER JOIN
    Members M ON BR.MEMBER_ID = M.MEMBER_ID
INNER JOIN
    Books B ON BR.BOOK_ID = B.BOOK_ID
WHERE
    M.MEMBER_ID = 1
    AND BR.RETURN_DATE IS NULL;
    
    


SELECT
    M.MEMBER_ID,
    M.NAME,
    B.TITLE,
    BR.BORROW_DATE,
    'Overdue' AS Status
FROM
    BorrowingRecords BR
INNER JOIN
    Members M ON BR.MEMBER_ID = M.MEMBER_ID
INNER JOIN
    Books B ON BR.BOOK_ID = B.BOOK_ID
WHERE
    BR.RETURN_DATE IS NULL
    AND BR.BORROW_DATE < (CURRENT_DATE() - INTERVAL 30 DAY);



SELECT
    GENRE,
    SUM(AVAILABLE_COPIES) AS TotalAvailableCopies
FROM
    Books
GROUP BY
    GENRE
ORDER BY
    TotalAvailableCopies DESC;
    
    
SELECT
    B.TITLE,
    B.AUTHOR,
    COUNT(BR.BOOK_ID) AS BorrowCount
FROM
    BorrowingRecords BR
INNER JOIN
    Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY
    B.BOOK_ID, B.TITLE, B.AUTHOR
ORDER BY
    BorrowCount DESC
LIMIT 1;
  
  
  
SELECT
    M.MEMBER_ID,
    M.NAME,
    COUNT(DISTINCT B.GENRE) AS GenreCount
FROM
    Members M
INNER JOIN
    BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
INNER JOIN
    Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY
    M.MEMBER_ID, M.NAME
HAVING
    COUNT(DISTINCT B.GENRE) >= 3;
    

   


  SELECT
    DATE_FORMAT(BORROW_DATE, '%Y-%m') AS BorrowMonth,
    COUNT(BORROW_ID) AS TotalBorrowed
FROM
    BorrowingRecords
GROUP BY
    BorrowMonth
ORDER BY
    BorrowMonth DESC;



 SELECT
    M.MEMBER_ID,
    M.NAME,
    COUNT(BR.BORROW_ID) AS TotalBorrows
FROM
    Members M
INNER JOIN
    BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
GROUP BY
    M.MEMBER_ID, M.NAME
ORDER BY
    TotalBorrows DESC
LIMIT 3;


SELECT
    B.AUTHOR,
    COUNT(BR.BORROW_ID) AS TotalBorrows
FROM
    BorrowingRecords BR
INNER JOIN
    Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY
    B.AUTHOR
HAVING
    COUNT(BR.BORROW_ID) >= 10;---- NO OUTPUT SINCE MAX BORROWED BOOKS ARE 3



SELECT
    M.MEMBER_ID,
    M.NAME,
    M.MEMBERSHIP_DATE
FROM
    Members M
LEFT JOIN
    BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
WHERE
    BR.BORROW_ID IS NULL;
    


