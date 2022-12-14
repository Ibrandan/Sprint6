-- Problematica 1
-- Punto 1
CREATE TABLE "tipo_cuenta"(
    type_id PRIMARY KEY,
    type_account TEXT NOT NULL DEFAULT "Caja de Ahorro en Pesos"
);
CREATE TABLE "tipo_cliente" (
    client_id PRIMARY KEY,
    type_client TEXT NOT NULL DEFAULT "Classic"
);
CREATE TABLE "marcas_tarjeta" (
    brand_id PRIMARY KEY,
    type_brand TEXT NOT NULL DEFAULT "VISA"
);

INSERT INTO "tipo_cliente" VALUES
(1,"Classic"),(2,"Gold"),(3,"Black");

INSERT INTO "tipo_cuenta" VALUES
(1,"Caja de Ahorro en Pesos"),(2,"Caja de Ahorro en Dolares"),(3,"Cuenta Corriente");

INSERT INTO "marcas_tarjeta" VALUES
(1,"VISA"),(2,"MASTERCARD"),(3,"AMERICAN EXPRESS");

-- Punto 2, 3, 4--

CREATE TABLE "Tarjeta"(
    card_id INTEGER PRIMARY KEY,
    card_number TEXT UNIQUE CHECK (length(card_number)<20),
    card_cvv INT NOT NULL,
    card_gived TEXT,
    card_expiration TEXT,
    card_type TEXT,
    card_brand INTEGER,
    client INTEGER,
    
    FOREIGN KEY (card_brand) REFERENCES marcas_tarjeta(brand_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (client) REFERENCES cliente(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Punto 5

-- El punto 5 se realiza mediante la importacion del archivo Tarjeta.csv

-- Punto 6

CREATE TABLE "Direccion_cliente"(
    address_client_id PRIMARY KEY,
    address_type_client TEXT NOT NULL DEFAULT "CLIENTE"
);

INSERT INTO "Direccion_cliente" VALUES
(1,"CLIENTE"),(2,"EMPLEADO"),(3,"SUCURSAL");

CREATE TABLE "Direccion"(
    address_id INTEGER PRIMARY KEY,
    address_street TEXT NOT NULL,
    address_street_number TEXT NOT NULL,
    address_city TEXT NOT NULL,
    address_country TEXT NOT NULL,
    address_type_required INTEGER,

    FOREIGN KEY (address_type_required) REFERENCES Direccion_cliente(address_client_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- El punto 7 se realiza mediante la importacion del archivo Direccion.csv

-- Punto 8

ALTER TABLE cuenta ADD account_type INTEGER REFERENCES tipo_cuenta(type_id);

-- Punto 9
 
UPDATE cuenta SET account_type = ((abs(random() % 3 )))+1;

-- Punto 10

UPDATE empleado SET employee_hire_date = substr(employee_hire_date, 7)||"-"||substr(employee_hire_date, 4,2)||"-"||substr(employee_hire_date, 1,2);

-- Problematica 2

/* Crear Vista con las columnas id, numero sucursal, nombre, apellido, DNI 
 y edad de la tabla cliente calculada a partir de la fecha de nacimiento */

CREATE VIEW listado_clientes AS
SELECT customer_id,
    branch_id,
    customer_name,
    customer_surname,
    customer_DNI,
    strftime('%Y-%m-%d', date('now')) - strftime('%Y-%m-%d', date(dob)) AS 'customer_age'
FROM cliente;

/* Mostrar las columnas de los clientes, ordenadas por el DNI de menor 
 a mayor y cuya edad sea superior a 40 a??os */

SELECT *
from listado_clientes
WHERE customer_age > 40
ORDER by customer_DNI;

/*  Mostrar todos los clientes que se llaman ???Anne??? o ???Tyler??? ordenados 
 por edad de menor a mayor*/

SELECT *
FROM listado_clientes
WHERE customer_name = 'Anne' OR customer_name = 'Tyler'
ORDER by customer_age;

/* Insertar 5 nuevos clientes en la base de datos y 
 verificar que se haya realizado con ??xito la inserci??n */

INSERT INTO cliente(
        customer_name,
        customer_surname,
        customer_DNI,
        branch_id,
        dob
    )
VALUES
('Lois', 'Stout', '47730534', 80, '1984-07-07'),
('Hall', 'Mcconnell', '52055464', 45, '1968-04-30'),
('Hilel', 'Mclean', '43625213', 77, '1993-03-28'),
('Jin', 'Cooley', '21207908', 96, '1959-08-24'),
('Gabriel', 'Harmon', '57063950', 27, '1976-04-01');

SELECT *
FROM listado_clientes
WHERE customer_DNI IN ( '47730534' , '52055464', '43625213', '21207908',  '57063950');

/*  Actualizar 5 clientes recientemente agregados en la base de datos dado que 
 hubo un error en el JSON que tra??a la informaci??n, la sucursal de todos es 
 la 10 */

UPDATE cliente
SET branch_id = 10
WHERE customer_DNI IN ( '47730534' , '52055464', '43625213', '21207908',  '57063950');

/* Eliminar el registro correspondiente a ???Noel David??? realizando la selecci??n 
 por el nombre y apellido */

DELETE FROM cliente
WHERE customer_name = 'Noel' AND customer_surname = 'David';

/*  Consultar sobre cu??l es el tipo de pr??stamo de mayor importe */

SELECT loan_type AS Tipo_Prestamo, max(loan_total) AS Mayor_Importe FROM prestamo;

/* MAX() es una funci??n que devuelve el valor m??ximo en un conjunto de registros.*/

-- Problematica 3

--Punto 1
SELECT account_id,balance
FROM cuenta
WHERE balance < 0
ORDER BY account_id;

--Punto 2
SELECT customer_name, customer_surname, customer_age
FROM listado_clientes
WHERE customer_surname LIKE '%Z%'
ORDER BY customer_surname;

--Punto 3
SELECT customer_name, customer_surname, customer_age, branch_name
FROM listado_clientes
INNER JOIN sucursal ON listado_clientes.branch_id = sucursal.branch_id
WHERE customer_name = 'Brendan'
ORDER BY branch_name;

--Punto 4
SELECT * FROM prestamo WHERE loan_total > 8000000
UNION
SELECT * FROM prestamo WHERE loan_type = 'PRENDARIO'

--Punto 5
SELECT loan_total, customer_name, customer_surname
FROM prestamo
INNER JOIN cliente ON cliente.customer_id = prestamo.loan_id
WHERE loan_total > (
    SELECT AVG(ALL loan_total)FROM prestamo
);

--Punto 6
SELECT count(*) FILTER( WHERE customer_age < 50) AS menores_50
FROM listado_clientes;

--Punto 7
SELECT *
FROM cuenta
WHERE balance > 800000
LIMIT 5;

--Punto 8
SELECT loan_total,
    loan_type,
    loan_date
FROM prestamo
WHERE strftime('%m', date(loan_date)) = '04'
    OR strftime('%m', date(loan_date)) = '06'
    OR strftime('%m', date(loan_date)) = '08'
ORDER BY loan_total;

--Punto 9
SELECT loan_type,
    sum(loan_total) AS loan_total_accu
FROM prestamo
WHERE loan_total IS NOT NULL
GROUP BY loan_type
ORDER BY loan_type;

--Problematica 4

--Punto 1

SELECT cliente.branch_id AS ID_SUCURSAL , sucursal.branch_name AS NOMBRE_SUCURSAL, count(all cliente.branch_id) AS Cantidad
FROM cliente INNER JOIN sucursal ON cliente.branch_id = sucursal.branch_id
GROUP BY sucursal.branch_id ORDER BY sucursal.branch_name DESC;

--Punto 2

CREATE VIEW empleadosporcliente AS SELECT 
sucursal.branch_id, sucursal.branch_name AS NOMBRE_SUCURSAL, 
count(DISTINCT empleado.employee_id) FILTER(WHERE empleado.branch_id = sucursal.branch_id)AS CANTIDAD_EMPLEADOS,
count(DISTINCT cliente.customer_id) FILTER(WHERE cliente.branch_id = sucursal.branch_id) AS CANTIDAD_CLIENTES
FROM sucursal INNER JOIN empleado ON sucursal.branch_id = empleado.branch_id INNER JOIN cliente ON sucursal.branch_id = cliente.branch_id
GROUP BY sucursal.branch_name ORDER BY sucursal.branch_name;

/*Se crea una vista para poder operar valores*/

SELECT NOMBRE_SUCURSAL, CANTIDAD_CLIENTES, CANTIDAD_EMPLEADOS, ROUND((CAST(CANTIDAD_EMPLEADOS AS REAL)/CANTIDAD_CLIENTES),2) AS EMPLEADOS_X_CLIENTE FROM empleadosporcliente

/*Se resuelve el calculo sobre los valores de la vista*/

--Punto 3

SELECT sucursal.branch_name AS NOMBRE_SUCURSAL, count(ALL card_id) FILTER
(WHERE Tarjeta.card_type = "CREDITO") AS CANTIDAD_TARJETAS 
FROM sucursal INNER JOIN cliente ON sucursal.branch_id = cliente.branch_id INNER JOIN Tarjeta ON Tarjeta.client = cliente.customer_id
GROUP BY sucursal.branch_name ORDER BY sucursal.branch_name;

--Punto 4

SELECT sucursal.branch_name AS NOMBRE_SUCURSAL, AVG(prestamo.loan_total) AS promedio_segun_sucursal
FROM prestamo
INNER JOIN sucursal ON sucursal.branch_id = cliente.branch_id
INNER JOIN cliente ON prestamo.customer_id = cliente.customer_id
GROUP BY sucursal.branch_id;

--Punto 5

/*Creacion de la Tabla*/

CREATE TABLE "auditoria_cuenta" (
    audit_id INTEGER PRIMARY KEY AUTOINCREMENT,
    old_id INTEGER,
    new_id INTEGER,
    old_balance INTEGER,
    new_balance INTEGER,
    old_iban TEXT,
    new_iban TEXT,
    old_type INTEGER,
    new_type INTEGER,
    user_action TEXT,
    created_at TEXT NOT NULL
);

/*Creacion del Trigger*/

CREATE TRIGGER tr_update_cuenta
BEFORE UPDATE ON cuenta WHEN old.balance <> new.balance OR old.iban <> new.iban OR old.account_type <> new.type
BEGIN
	INSERT INTO auditoria_cuenta (old_id, new_id, old_balance, new_balance, old_iban, new_iban, old_type, new_type, user_action, created_at)
	VALUES (old.id, new.id, old.balance, new.balance, old.iban, new.iban, old.type, new.type, "UPDATE", date(now));
END;

/*Resta $100 de las cuentas ID 10,11,12,13 y 14*/

UPDATE cuenta SET balance = balance - 10000
WHERE account_id IN (10,11,12,13,14);

/*Crea un indice en base al DNI*/

CREATE unique INDEX indice_dni ON cliente(customer_DNI);

/*Punto 6*/

/*Creacion de Tabla movimientos*/

CREATE TABLE movimientos (
	movement_id INTEGER PRIMARY KEY AUTOINCREMENT,
	account_number INTEGER,
	amount REAL,
	operation_type TEXT,
	hora TEXT
);

/*Transaccion desde la cuenta 200 a la 400*/

BEGIN TRANSACTION;

UPDATE OR ROLLBACK cuenta  
SET balance = balance - 100000
WHERE account_id = 200;

UPDATE OR ROLLBACK cuenta  
SET balance = balance + 100000
WHERE account_id = 400;

/*Registra el movimiento en la tabla movimientos, controlar por ROLLBACK si funciono o no*/

INSERT OR ROLLBACK INTO movimientos(account_number, amount, operation_type, hora)
VALUES (200,1000,"TRANSFERENCIA",datetime()),(400,1000,"TRANSFERENCIA",datetime());

COMMIT;

