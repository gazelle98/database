#Queries

#1
SELECT address
FROM Branch
WHERE bcode = (
	SELECT bcode
	FROM Bank 
	WHERE name = 'Mellat'
);

#2
SELECT DISTINCT first_name, last_name, address, phone_no
FROM Customer
WHERE cid = (
	SELECT cid
	FROM Account
	WHERE balance >= 1000000
);

#3
SELECT l.amount, c.first_name, c.last_name
FROM Loan l, Customer c
WHERE l.amount = (
	SELECT max(amount)
	FROM Loan
	) AND l.cid = c.cid;

#4
SELECT sum(balance)
FROM Account
WHERE brid = (
	SELECT brid
	FROM Branch
	WHERE bcode = (
		SELECT bcode
		FROM Bank
		WHERE name = 'Refah'
));

#5
SELECT balance
FROM Account
WHERE cid = (
	SELECT cid
	FROM Customer
	WHERE last_name = 'Irani'
);

#6
SELECT count(c.cid), br.address
FROM Customer c, Branch br , Bank b
WHERE b.name = 'Keshavarzi' AND c.brid = br.brid AND br.bcode = b.bcode
GROUP BY br.brid;

#7
SELECT type
FROM Loan
WHERE brid = (
	SELECT brid
	FROM Branch
	WHERE bcode = (
		SELECT bcode
		FROM Bank
		WHERE name = 'Maskan'
));

#8
SELECT count(*)
FROM Branch
WHERE bcode = (
	SELECT bcode
	FROM Bank
	WHERE name = 'Ayande'
);

#9
SELECT c.address
FROM Customer c, Branch br, Bank b
WHERE b.bcode = br.bcode AND b.name = 'Sepah' AND c.brid = br.brid AND c.cid = (
	SELECT cid
    FROM Account
    WHERE acc_no = (
		SELECT max(acc_no) FROM Account)
        );
