--Crear una vista que indica cual es el producto más vendido
--(Nombre del producto, nombre de la linea de producto, venta total del producto, utilidad -> paidPrice - buyPrice)

CREATE VIEW BESTSELLER AS
SELECT products.productName as nombreProducto, productlines.productLine as lineaProducto, SUM(orderdetails.priceEach - products.buyPrice) as utilidadProducto, SUM(quantityOrdered * priceEach) as ventaTotal
FROM products, productlines, orderdetails
WHERE products.productCode = orderdetails.productCode AND products.productLine = productlines.productLine
GROUP BY products.productCode
ORDER BY SUM(quantityOrdered) DESC
LIMIT 1;
	

--Crear una vista que visualiza cual ha sido el cliente con mayor cantidad de compras (Parametrizar por rango de fecha)
--(Nombre del cliente, Venta total por cliente, numero de diferentes productos que ha adquirido el cliente)


CREATE VIEW BESTCLIENT AS
SELECT customers.customerName AS nombreCliente,SUM(orderdetails.quantityOrdered * orderdetails.priceEach) as ventaTotalCliente,
       COUNT(DISTINCT (orderdetails.productCode)) AS productosDiferentes, MIN(orders.orderDate) AS fechaInicio, MAX(orders.orderDate )as fechaFin
FROM customers, orderdetails, orders
WHERE customers.customerNumber = orders.customerNumber AND orders.orderNumber = orderdetails.orderNumber
GROUP BY customers.customerName
ORDER BY productosDiferentes DESC, fechaInicio, fechaFin
LIMIT 1;

