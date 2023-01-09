-- declaración para eliminar tablas que se puedan repetir
DROP TABLE IF EXISTS cliente_pedidos_productos;
DROP TABLE IF EXISTS cliente_pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS proveedores;
DROP TABLE IF EXISTS productos;

-- tabla de clientes
CREATE TABLE clientes(
	cliente_id SERIAL PRIMARY KEY,
	cliente_nombre VARCHAR(50),
	cliente_rut VARCHAR(15)
);

SELECT * FROM clientes;

-- tabla de productos (detalle del pedido)
CREATE TABLE productos(
	producto_id SERIAL PRIMARY KEY,
	producto_nombre VARCHAR(50),
	producto_precio_neto NUMERIC(15) CHECK(producto_precio_neto >= 0),
	producto_stock SMALLINT CHECK(producto_stock >= 0) DEFAULT 0,
	producto_tipo VARCHAR(20)
);

SELECT * FROM productos;

-- tabla de proveedores
CREATE TABLE proveedores(
	proveedor_id SERIAL PRIMARY KEY,
	producto_id INT REFERENCES productos(producto_id),
	proveedor_nombre VARCHAR(50),
	proveedor_rut VARCHAR(15),
	proveedor_categoria VARCHAR(20)
);


SELECT * FROM proveedores;


-- tabla del pedido del cliente
CREATE TABLE cliente_boletas(
	cliente_pedido_id SERIAL PRIMARY KEY,
	cliente_id INT REFERENCES clientes(cliente_id),
	producto_id INT REFERENCES  productos(producto_id),
	orden_fecha DATE,
	cantidad SMALLINT DEFAULT 1,
	valor_neto NUMERIC(15)  CHECK(valor_neto >= 0)
	
);

SELECT * FROM cliente_boletas;


-- insertamos los productos a la tabla de productos
INSERT INTO productos
(producto_nombre, producto_precio_neto, producto_stock, producto_tipo)
VALUES 
	('Salmón', 15000, 90, 'pescados'),
	('Camarón', 10000, 70, 'mariscos'),
	('Pulpo', 12000, 4, 'mariscos'),
	('Arroz', 1000, 5, 'abarrotes'),
	('Palta', 3500, 3, 'verduras'),
	('Pechuga de pollo', 3500, 15, 'carnes'),
	('Azucar', 1000, 10, 'abarrotes'),
	('Cebolla morada', 1000, 8, 'verduras'),
	('Almendras', 5000, 3, 'frutos secos'),
	('Queso crema', 7000, 20, 'lacteos'),
	('Nueces', 5000, 10, 'frutos secos'),
	('Lechugas', 1000, 18, 'verduras'),
	('Leche descremada', 1500, 7, 'lacteos'),
	('Tilapia', 5000, 60, 'pescados'),
	('Atún', 18000, 80, 'pescados'),
	('Ostras', 5000, 55, 'mariscos');
	
	
-- insertamos lista de clientes a tabla de clientes
INSERT INTO clientes
(cliente_nombre, cliente_rut)
VALUES
	('María Jimenez', '14568922-4'),
	('Carmen Soto', '13663998-2'),
	('Josefa Martinez', '10457532-3'),
	('Antonio Parra', '8289536-0'),
	('José Moreno', '15601368-9'),
	('Manuel Rodriguez', '13522612-3'),
	('David Perez', '7457559-5'),
	('Daniel Ibarra', '18502339-8');

-- insertamos proveedores a tabla de proveedores
INSERT INTO proveedores
(producto_id, proveedor_nombre, proveedor_rut, proveedor_categoria)
VALUES 
	(6,'Agrosuper', '30290321-0', 'carnes'),
	(1,'Tranmar', '25789658-0', 'pescados'),
	(5, 'Full agro', '06289546-8', 'verduras'),
	(10, 'Soprole', '35265987-4', 'lacteos'),
	(7, 'Distribuidora Lira', '27549892-3', 'abarrotes'),
	(4, 'Casa Japonesa', '22653231-0', 'abarrotes');


-- 1-.actualizar el precio de todos los productos, -20% por concepto de oferta de verano.
UPDATE productos
SET producto_precio_neto = producto_precio_neto * 0.8;

SELECT * FROM productos;

-- 2-.listar todos los productos con stock critico(menor o igual a 5 unidades)
SELECT producto_nombre, producto_stock
FROM productos
WHERE producto_stock <= 5;

-- 3-.simular la compra de al menos 3 productos, calcular el subtotal, agregar IVA y mostrar el total de la compra.
-- insertamos 3 ventas
INSERT INTO cliente_boletas
(cliente_id, producto_id, orden_fecha, cantidad, valor_neto)
VALUES
	(3, 1, '2022/12/10', 10, 120000),
	(3, 2, '2022/12/10', 10, 80000),
	(4, 1, '2022/12/12', 10, 120000);
-- calculamos el subtotal, el IVA y el total a pagar
SELECT (
	SELECT SUM(valor_neto)
	FROM cliente_boletas
	WHERE cliente_pedido_id IN (1, 2)
) * 1.2 AS valor_total;

-- 4-. mostrar el total de ventas de mes de diciembre del 2022
-- total monto de ventas
SELECT (
	SELECT SUM(valor_neto) AS total_ventas
	FROM cliente_boletas
	WHERE EXTRACT(MONTH FROM orden_fecha) = 12
) * 1.2 AS total_mes

-- total de ventas
SELECT COUNT(cliente_pedido_id) AS cantidad_ventas
FROM cliente_boletas

-- 5-.listar el comportamiento de compra del usuario que mas compras realizo durante 2022
SELECT cliente_id, COUNT(*) AS cantidad_compras
FROM cliente_boletas
WHERE EXTRACT(YEAR FROM orden_fecha) = 2022
GROUP BY cliente_id
ORDER BY cantidad_compras DESC
LIMIT 1





