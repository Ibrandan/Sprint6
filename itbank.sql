-- Problematica 1
CREATE TABLE "tipos_cuentas"(
    clase TEXT NOT NULL UNIQUE,
    descubierto INTEGER NOT NULL,
    comisiones_transferencia REAL NOT NULL,
    max_extracciones INTEGER NOT NULL,
    max_chequeras INTEGER NOT NULL,
    max_tarjetas INTEGER NOT NULL,
    max_transferencias_recibida INTEGER,
    puede_comprar_dolar TEXT NOT NULL
);
CREATE TABLE "tipo_cliente" (
    client_id INTEGER NOT NULL,
    tipo_cuenta TEXT NOT NULL,
    tipo_tarjeta TEXT,
    numero INTEGER UNIQUE NOT NULL,
    CVV INTEGER NOT NULL,
    fecha_otorgamiento TEXT NOT NULL,
    vencimiento TEXT NOT NULL,
    marca_id INTEGER NOT NULL
);
CREATE TABLE "marcas_tarjeta" (
    marca_id INTEGER NOT NULL UNIQUE,
    marca TEXT NOT NULL
);
INSERT INTO tipos_cuentas (
        clase,
        descubierto,
        comisiones_transferencia,
        max_extracciones,
        max_chequeras,
        max_tarjetas,
        max_transferencias_recibida,
        puede_comprar_dolar
    )
VALUES ("CLASSIC", 0, 1, 10000, 0, 0, 150000, "NO"),
    ("GOLD", 10000, 0.5, 20000, 1, 1, 500000, "SI"),
    ("BLACK", 10000, 0, 100000, 2, 5, NULL, "SI");
INSERT INTO marcas_tarjeta (marca_id, marca)
VALUES (1, "Maestro"),
    (2, "American Express"),
    (3, "Diners Club"),
    (4, "Discover"),
    (5, "MasterCard"),
    (6, "Visa");
INSERT INTO tipo_cliente (
        client_id,
        tipo_cuenta,
        tipo_tarjeta,
        numero,
        CVV,
        fecha_otorgamiento,
        vencimiento,
        marca_id
    )
SELECT ID,
    TIPOCUENTA,
    TIPOTARJETA,
    NUMERO,
    cvv,
    otorgado,
    vencimiento,
    numberrange
FROM tarjetas_csv;
UPDATE tipo_cliente
SET tipo_tarjeta = "DEBITO"
WHERE tipo_cuenta = "CLASSIC";
UPDATE tipo_cliente
SET tipo_tarjeta = "CREDITO"
WHERE NOT tipo_cuenta = "CLASSIC"
    AND tipo_tarjeta = "NULL";
CREATE TABLE direcciones (id INTEGER, tipo TEXT, dir TEXT);
INSERT INTO direcciones (id, tipo, dir)
SELECT id,
    tipo_direccion,
    direccion
FROM direcciones_csv;
UPDATE direcciones
SET tipo = "SUCURSAL"
WHERE NOT EXISTS(
        SELECT id
        FROM direcciones
        WHERE tipo = id
    )
    AND tipo = "NULL"
    AND random() > 0
    AND id BETWEEN 1 AND 100;
UPDATE direcciones
SET tipo = "CLIENTE"
WHERE tipo = "NULL"
    AND random() > 0;
UPDATE direcciones
SET tipo = "EMPLEADO"
WHERE tipo = "NULL";
ALTER TABLE cliente
ADD COLUMN tipo;
UPDATE cliente
SET tipo = (
        SELECT tipo_cuenta
        FROM tipo_cliente
        WHERE client_id = cliente.customer_id
    );
-- Problematica 2
/* Vista con las columnas id, numero sucursal, nombre, apellido, DNI 
 y edad de la tabla cliente calculada a partir de la fecha de nacimiento */
/*
 Crear en la base de datos los tipos de cliente, de cuenta y marcas de 
 tarjeta. Insertar los valores según la información provista en el Sprint 
 5 
 */
-- Problematica 2
CREATE VIEW listado_clientes as
SELECT customer_id,
    branch_id,
    customer_name,
    customer_surname,
    customer_DNI,
    strftime('%Y', date('now')) - strftime('%Y', date(dob)) AS 'customer_age'
FROM cliente;
/* strftime() devuelve la fecha formateada como se indica en el primer argumento. El segundo parámetro se usa para mencionar la cadena de tiempo, pueder ser la fecha actual, fecha de nacimiento, etc. */
/* Mostrar las columnas de los clientes, ordenadas por el DNI de menor 
 a mayor y cuya edad sea superior a 40 años */
SELECT *
from listado_clientes
WHERE customer_age > 40
ORDER by customer_DNI;
/*  Mostrar todos los clientes que se llaman “Anne” o “Tyler” ordenados 
 por edad de menor a mayor*/
SELECT *
FROM listado_clientes
WHERE customer_name = 'Anne'
    or customer_name = 'Tyler'
ORDER by customer_age;
/* Insertar 5 nuevos clientes en la base de datos y 
 verificar que se haya realizado con éxito la inserción */
INSERT INTO cliente(
        customer_name,
        customer_surname,
        customer_DNI,
        branch_id,
        dob
    )
VALUES('Lois', 'Stout', '47730534', 80, '1984-07-07');
INSERT INTO cliente(
        customer_name,
        customer_surname,
        customer_DNI,
        branch_id,
        dob
    )
VALUES(
        'Hall',
        'Mcconnell',
        '52055464',
        45,
        '1968-04-30'
    );
INSERT INTO cliente(
        customer_name,
        customer_surname,
        customer_DNI,
        branch_id,
        dob
    )
VALUES('Hilel', 'Mclean', '43625213', 77, '1993-03-28');
INSERT INTO cliente (
        customer_name,
        customer_surname,
        customer_DNI,
        branch_id,
        dob
    )
VALUES('Jin', 'Cooley', '21207908', 96, '1959-08-24');
INSERT INTO cliente(
        customer_name,
        customer_surname,
        customer_DNI,
        branch_id,
        dob
    )
VALUES(
        'Gabriel',
        'Harmon',
        '57063950',
        27,
        '1976-04-01'
    );
SELECT *
FROM listado_clientes
WHERE customer_DNI = '47730534';
SELECT *
FROM listado_clientes
WHERE customer_DNI = '52055464';
SELECT *
FROM listado_clientes
WHERE customer_DNI = '43625213';
SELECT *
FROM listado_clientes
WHERE customer_DNI = '21207908';
SELECT *
FROM listado_clientes
WHERE customer_DNI = '57063950';
/*  Actualizar 5 clientes recientemente agregados en la base de datos dado que 
 hubo un error en el JSON que traía la información, la sucursal de todos es 
 la 10 */
UPDATE cliente
set branch_id = 10
WHERE customer_DNI = '47730534';
UPDATE cliente
set branch_id = 10
WHERE customer_DNI = '52055464';
UPDATE cliente
set branch_id = 10
WHERE customer_DNI = '43625213';
UPDATE cliente
set branch_id = 10
WHERE customer_DNI = '21207908';
UPDATE cliente
set branch_id = 10
WHERE customer_DNI = '57063950';
/* Eliminar el registro correspondiente a “Noel David” realizando la selección 
 por el nombre y apellido */
DELETE FROM cliente
WHERE customer_name = 'Noel'
    AND customer_surname = 'David';
/*  Consultar sobre cuál es el tipo de préstamo de mayor importe */
-- Primer opción
SELECT loan_type,
    max(loan_total)
FROM prestamo;
/* MAX() es una función que devuelve el valor máximo en un conjunto de registros.*/
-- Segunda opción
SELECT *
from prestamo
ORDER by loan_total DESC
LIMIT 1;
-- Problematica 3
--Punto 1
SELECT account_id,
    balance
FROM cuenta
WHERE balance >= 0
ORDER BY account_id;
--Punto 2
SELECT customer_name,
    customer_surname,
    strftime('%Y', date('now')) - strftime('%Y', date(dob)) AS 'customer_age'
FROM cliente
WHERE customer_surname LIKE '%Z%'
ORDER BY customer_surname;
--Punto 3
SELECT customer_name,
    customer_surname,
    strftime('%Y', date('now')) - strftime('%Y', date(dob)) AS 'customer_age',
    branch_name
FROM cliente
    INNER JOIN sucursal ON cliente.branch_id = sucursal.branch_id
WHERE customer_name = 'Brendan'
ORDER BY branch_name;
--Punto 4
SELECT loan_total,
    loan_type,
    customer_name,
    customer_surname
FROM prestamo
    INNER JOIN cliente ON cliente.customer_id = prestamo.loan_id
WHERE loan_total > 80000
    OR loan_type = 'PRENDARIO';
--Punto 5
SELECT loan_total,
    customer_name,
    customer_surname
FROM prestamo
    INNER JOIN cliente ON cliente.customer_id = prestamo.loan_id
WHERE loan_total > (
        SELECT AVG(ALL loan_total)
        FROM prestamo
    );
--Punto 6
SELECT count(*) FILTER(
        WHERE (
                strftime('%Y', date('now')) - strftime('%Y', date(dob))
            ) < 50
    ) AS menores_50
FROM cliente;
--Punto 7
SELECT balance
FROM cuenta
WHERE balance > 8000
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

SELECT branch_name,
    count(customer_id)
FROM cliente c
    LEFT JOIN sucursal s ON s.branch_id = c.branch_id
GROUP BY branch_name
ORDER BY count(customer_id) DESC;
