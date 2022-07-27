-- Problematica 2

CREATE VIEW listado_clientes
as
SELECT
customer_id, branch_id,customer_name, customer_surname, customer_DNI, strftime('%Y',date('now')) - strftime('%Y',date(dob)) AS 'customer_age'
FROM cliente;

SELECT * from listado_clientes WHERE customer_age > 40 ORDER by customer_DNI;

SELECT * FROM listado_clientes WHERE customer_name = 'Anne' or customer_name = 'Tyler' ORDER by customer_age;

INSERT INTO cliente(customer_name, customer_surname, customer_DNI, branch_id, dob)
VALUES('Lois', 'Stout', '47730534', 80,'1984-07-07');

INSERT INTO cliente(customer_name, customer_surname, customer_DNI, branch_id, dob)
VALUES('Hall', 'Mcconnell', '52055464', 45,'1968-04-30');

INSERT INTO cliente(customer_name, customer_surname, customer_DNI, branch_id, dob)
VALUES('Hilel', 'Mclean', '43625213', 77,'1993-03-28');

INSERT INTO cliente (customer_name, customer_surname, customer_DNI, branch_id, dob)
VALUES('Jin', 'Cooley', '21207908', 96,'1959-08-24');

INSERT INTO cliente(customer_name, customer_surname, customer_DNI, branch_id, dob)
VALUES('Gabriel','Harmon', '57063950', 27,'1976-04-01');

SELECT * FROM listado_clientes WHERE customer_DNI = '47730534'; 
SELECT * FROM listado_clientes WHERE customer_DNI = '52055464';
SELECT * FROM listado_clientes WHERE customer_DNI = '43625213';
SELECT * FROM listado_clientes WHERE customer_DNI = '21207908';
SELECT * FROM listado_clientes WHERE customer_DNI = '57063950';

UPDATE cliente set branch_id = 10 WHERE customer_DNI = '47730534';
UPDATE cliente set branch_id = 10 WHERE customer_DNI = '52055464';
UPDATE cliente set branch_id = 10 WHERE customer_DNI = '43625213';
UPDATE cliente set branch_id = 10 WHERE customer_DNI = '21207908';
UPDATE cliente set branch_id = 10 WHERE customer_DNI = '57063950';

DELETE FROM cliente WHERE customer_name = 'Noel' AND customer_surname = 'David';

SELECT loan_type, max(loan_total) FROM prestamo;

SELECT * from prestamo ORDER by loan_total DESC LIMIT 1; 