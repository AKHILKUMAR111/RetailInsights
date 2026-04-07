--Table creation
CREATE TABLE Category (category_id NUMBER PRIMARY KEY,category_name VARCHAR2(50));
CREATE TABLE Products (product_id NUMBER PRIMARY KEY,category_id NUMBER ,expiry_date date ,quantity NUMBER,price NUMBER,FOREIGN KEY (category_id) REFERENCES Category(category_id));
CREATE TABLE SalesTransaction (transaction_id NUMBER PRIMARY KEY,product_id NUMBER,sold_date DATE ,quantity_sold NUMBER,FOREIGN KEY (product_id) REFERENCES Products(product_id) );




--Dummy date insertion
INSERT INTO Category (category_id,category_name) VALUES (101,'Electronics'),(102,'clothings'),(103,'Protein_powder');

INSERT INTO Products (product_id, category_id, expiry_date, quantity, price) VALUES 
(1,101,SYSDATE + 3,100 ,2.50),
(2,102,SYSDATE + 20,10,3.00),
(3,103,ADD_MONTHS(SYSDATE, 12),5,500.00);

INSERT INTO SalesTransaction (transaction_id, product_id, sold_date, quantity_sold) VALUES
(1001,1,SYSDATE - 10,5),
(1002,2,SYSDATE - 5,2),
(1003, 3,ADD_MONTHS(SYSDATE, -6),1);


--DQL commands 
SELECT *
FROM Products
WHERE quantity>50 AND expiry_date BETWEEN SYSDATE AND SYSDATE + 7;

SELECT p.* FROM Products p
LEFT JOIN (SELECT * FROM SalesTransaction  WHERE sold_date BETWEEN ADD_MONTHS(SYSDATE,-2) AND SYSDATE
) s ON p.product_id=s.product_id
WHERE s.product_id IS NULL;


SELECT * 
FROM Products p
WHERE p.product_id NOT IN (SELECT product_id FROM SalesTransaction WHERE sold_date BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE);


SELECT c.category_name AS category_name ,SUM(p.price*s.quantity_sold) AS revenue
FROM Products p
JOIN Category c ON p.category_id=c.category_id
JOIN SalesTransaction s ON s.product_id=p.product_id
WHERE s.sold_date>=ADD_MONTHS(SYSDATE, -1)
GROUP BY c.category_name
ORDER BY revenue DESC
FETCH FIRST 1 ROWS ONLY;



