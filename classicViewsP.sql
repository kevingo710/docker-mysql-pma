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

--Crear un procedimiento para ordenar un producto


DELIMITER //
CREATE PROCEDURE sp_orderProduct (orderNumberP INT, orderDateP DATE, requiredDateP DATE,
                                 shippedDateP DATE, statusP VARCHAR(15), commentsP TEXT,
                                 customerNumberP INT, productCodeP VARCHAR(15),
                                 quantityOrderedP INT, priceEachP DECIMAL(10, 2), orderLineNumberP SMALLINT)
BEGIN
    START TRANSACTION;
            INSERT  INTO `orders`(`orderNumber`,`orderDate`,`requiredDate`,`shippedDate`,`status`,`comments`,`customerNumber`)
            VALUES (orderNumberP,orderDateP,requiredDateP,shippedDateP,statusP,commentsP,customerNumberP);

            INSERT  INTO `orderdetails`(`orderNumber`,`productCode`,`quantityOrdered`,`priceEach`,`orderLineNumber`)
            VALUES  (orderNumberP,productCodeP,quantityOrderedP,priceEachP,orderLineNumberP);
END //
DELIMITER ;

--EXAMPLE

CALL sp_orderProduct(4040, curdate(), curdate(), curdate(), 'recibido', NULL,
              363, 'S18_1749', 20, 150.70, 7)

--TEST
SELECT * FROM orderdetails WHERE orderNumber = 4040;
SELECT * FROM orders WHERE orderNumber = 4040 ;

--PERMISSIONS
GRANT SELECT ON `classicmodels`.* TO 'marc'@'%';
GRANT SELECT, DELETE, UPDATE ON `classicmodels`.* TO 'marc'@'%';
GRANT EXECUTE ON PROCEDURE classicmodels.sp_orderProduct TO 'marc'@'%';