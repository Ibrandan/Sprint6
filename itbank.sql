-- Problematica 2

CREATE VIEW listado_clientes
as
SELECT
customer_id, customer_name, customer_surname, customer_DNI, strftime('%Y',date('now')) - strftime('%Y',date(dob)) AS 'customer_age'
FROM cliente;

SELECT * from listado_clientes ORDER by customer_DNI;

SELECT * FROM listado_clientes WHERE customer_name = 'Anne' or customer_name = 'Tyler';