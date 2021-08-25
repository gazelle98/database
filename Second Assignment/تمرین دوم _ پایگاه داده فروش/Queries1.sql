#1
SELECT c.customerName, COUNT(*)
FROM Customers c, Orders o
WHERE c.customerNumber = o.customerNumber 
	AND c.country = 'Canada'
GROUP BY c.customerName;

#2
SELECT e.email, e.jobTitle
FROM Employees e
WHERE e.employeeNumber IN(
	SELECT c.salesRepEmployeeNumber
    FROM Customers c, Orders o, OrderDetails od, Products p
	WHERE c.customerNumber = o.customerNumber 
		AND o.orderNumber = od.orderNumber 
		AND od.productCode = p.productCode 
		AND p.productName = 'Ray-Ban Clubmaster eyeglasses'
    )
GROUP BY e.employeeNumber
HAVING count(*)>=10;

#3
SELECT c.customerNumber, RANK() OVER (ORDER BY sum(py.amount) DESC) AS Payment_Rank
FROM Customers c, Orders o, Products p, OrderDetails od, Payments py
WHERE py.customerNumber = c.customerNumber 
	AND c.customerNumber = o.customerNumber 
	AND o.orderNumber = od.orderNumber 
	AND od.productCode = p.productCode 
	AND p.productName = 'Pepsi'
GROUP BY c.customerNumber;


#Creating a table for product lines
CREATE TABLE ProductLines(
productLine VARCHAR(50),
textDescription TEXT,
htmlDescription TEXT,
image BLOB,
PRIMARY KEY(productLine),
FOREIGN KEY(productLine) REFERENCES Products(productCode)
)


#4
SELECT p.productLine
FROM Products p, OrderDetails od‌, Orders o, Customers c, Employees e, Offices off
WHERE c.salesRepEmployeeNumber = e.employeeNumber
	AND e.officeCode = off.officeCode
	AND off.city = 'Frankfurt'
	AND c.customerNumber = o.customerNumber
	AND o.orderNumber = od‌.orderNumber
	AND od‌.productCode = p.productCode
	AND c.country = 'Iran'
	AND od‌.priceEach = 100;

#5
SELECT sum(py.amount)
FROM Payments py, Customers c, Orders o
WHERE c.customerNumber IN(
	SELECT customerNumber
    FROM Customers
    WHERE city = 'New York'
		AND c.customerNumber = o.customerNumber
		AND o.shippedDate = '2018-02-10'
	)
	AND c.customerNumber = py.customerNumber
    AND py.paymentDate = '2018-03-12'
GROUP BY c.customerNumber;

#6
INSERT INTO Payments(customerNumber, checkNumber, paymentDate, amount)
VALUES(52, '530-3567', '2018-04-22', 200);

#7
UPDATE OrderDetails od
	JOIN Products p ON od.productCode = p.productCode
    JOIN (Orders o JOIN Customers c ON c.customerNumber = o.customerNumber) ON od.orderNumber = o.orderNumber
SET quantityOrdered = 2
WHERE p.productCode = 'DKC-1532'
	AND p.productLine = '3'
    AND c.customerNumber = 67;












