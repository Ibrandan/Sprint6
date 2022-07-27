/*  Crear una vista con las columnas id, numero sucursal, nombre, apellido, DNI 
y edad de la tabla cliente calculada a partir de la fecha de nacimiento
o Mostrar las columnas de los clientes, ordenadas por el DNI de menor 
a mayor y cuya edad sea superior a 40 años
o Mostrar todos los clientes que se llaman “Anne” o “Tyler” ordenados 
por edad de menor a mayor
 Dado el siguiente JSON. Insertar 5 nuevos clientes en la base de datos y 
verificar que se haya realizado con éxito la inserción
[
{
"customer_name": "Lois",
"customer_surname": "Stout",
"customer_DNI": 47730534,
"branch_id": 80,
"customer_dob": "1984-07-07"
},
{
"customer_name": "Hall",
"customer_surname": "Mcconnell",
"customer_DNI": 52055464,
"branch_id": 45,
"customer_dob": "1968-04-30"
},
{
"customer_name": "Hilel",
"customer_surname": "Mclean",
"customer_DNI": 43625213,
"branch_id": 77,
"customer_dob": "1993-03-28"
},
{
"customer_name": "Jin",
"customer_surname": "Cooley",
"customer_DNI": 21207908,
"branch_id": 96,
"customer_dob": "1959-08-24"
},
{
"customer_name": "Gabriel",
"customer_surname": "Harmon",
"customer_DNI": 57063950,
"branch_id": 27,
"customer_dob": "1976-04-01"
}
]
 Actualizar 5 clientes recientemente agregados en la base de datos dado que 
hubo un error en el JSON que traía la información, la sucursal de todos es 
la 10
 Eliminar el registro correspondiente a “Noel David” realizando la selección 
por el nombre y apellido
 Consultar sobre cuál es el tipo de préstamo de mayor importe */

-- Problematica 2

CREATE VIEW listado_clientes
as
SELECT
customer_id, customer_name, customer_surname, customer_DNI, strftime('%Y',date('now')) - strftime('%Y',date(dob)) AS 'customer_age'
FROM cliente;

SELECT * from listado_clientes ORDER by customer_DNI;

SELECT * FROM listado_clientes WHERE customer_name = 'Anne' or customer_name = 'Tyler';