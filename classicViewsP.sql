--Crear una vista que indica cual es el producto más vendido
--(Nombre del producto, nombre de la linea de producto, venta total del producto, utilidad -> paidPrice - buyPrice)

CREATE VIEW BESTSELLER AS
SELECT products.productName as nombreProducto, productlines.productLine as lineaProducto, SUM(orderdetails.priceEach - products.buyPrice) as utilidadProducto, SUM(quantityOrdered * priceEach) as ventaTotal
FROM products, productlines, orderdetails
WHERE products.productCode = orderdetails.productCode AND products.productLine = productlines.productLine
GROUP BY products.productCode
ORDER BY SUM(quantityOrdered) DESC
LIMIT 1;
	
