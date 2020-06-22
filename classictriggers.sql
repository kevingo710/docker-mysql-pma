USE classicmodels;

---1 
--CREAR TRIGGER DE PRODUCT BEFORE DELETE
DROP TABLE IF EXISTS ProductsRecovery;

CREATE TABLE ProductsRecovery
(
    productCode        varchar(15)    not null
        primary key,
    productName        varchar(70)    not null,
    productLine        varchar(50)    not null,
    productScale       varchar(10)    not null,
    productVendor      varchar(50)    not null,
    productDescription text           not null,
    quantityInStock    smallint       not null,
    buyPrice           decimal(10, 2) not null,
    MSRP               decimal(10, 2) not null,
    deletedAt TIMESTAMP DEFAULT NOW()
);



DELIMITER $$
DROP TRIGGER IF EXISTS before_products_delete;
CREATE TRIGGER before_products_delete
    BEFORE DELETE
    ON products FOR EACH ROW

BEGIN
    INSERT INTO ProductsRecovery( productCode, productCode, productLine, productScale, productVendor, productDescription ,
    quantityInStock, buyPrice,MSRP)

    VALUES (OLD.productCode, OLD.productCode, OLD.productLine, OLD.productScale, OLD.productVendor, OLD.productDescription,
            OLD.quantityInStock, OLD.buyPrice, OLD.MSRP);
END$$

DELIMITER ;


--CREAR TRIGGER DE PRODUCTLINES BEFORE DELETE

DROP TABLE IF EXISTS ProductsLinesRecovery;

CREATE TABLE ProductsLinesRecovery
(
    productLine     varchar(50)   not null
        primary key,
    textDescription varchar(4000) null,
    htmlDescription mediumtext    null,
    image           mediumblob    null,
    deletedAt TIMESTAMP DEFAULT NOW()
);



DELIMITER $$
DROP TRIGGER IF EXISTS before_productLines_delete;
CREATE TRIGGER before_productLines_delete
    BEFORE DELETE
    ON productlines FOR EACH ROW

BEGIN
    INSERT INTO ProductsLinesRecovery( productLine, textDescription, htmlDescription, image )

    VALUES (OLD.productLine, OLD.textDescription, OLD.htmlDescription, OLD.image);
END$$

DELIMITER ;

--CREATE TRIGGER DE CUSTOMERS
DROP TABLE IF EXISTS CustomersRecovery;

CREATE TABLE CustomersRecovery
(
    customerNumber         int            not null
        primary key,
    customerName           varchar(50)    not null,
    contactLastName        varchar(50)    not null,
    contactFirstName       varchar(50)    not null,
    phone                  varchar(50)    not null,
    addressLine1           varchar(50)    not null,
    addressLine2           varchar(50)    null,
    city                   varchar(50)    not null,
    state                  varchar(50)    null,
    postalCode             varchar(15)    null,
    country                varchar(50)    not null,
    salesRepEmployeeNumber int            null,
    creditLimit            decimal(10, 2) null,
    deletedAt TIMESTAMP DEFAULT NOW()
);



DELIMITER $$
DROP TRIGGER IF EXISTS before_Customers_delete;
CREATE TRIGGER before_Customers_delete
    BEFORE DELETE
    ON customers FOR EACH ROW

BEGIN
    INSERT INTO CustomersRecovery(customerNumber,
    customerName,
    contactLastName,
    contactFirstName,
    phone,
    addressLine1,addressLine2,city, postalCode, country, salesRepEmployeeNumber,creditLimit)

    VALUES (OLD.customerNumber, OLD.customerName, OLD.contactLastName, OLD.contactFirstName, OLD.phone, OLD.addressLine1,
            OLD.addressLine2, OLD.city, OLD.postalCode, OLD.country, OLD.salesRepEmployeeNumber, OLD.creditLimit);
END$$

DELIMITER ;

---2 TABLA EMPLOYES

use classicmodels;
DROP TABLE IF EXISTS exEmployees;
CREATE TABLE exEmployees
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    employeeNumber int(11) not null,
    lastName varchar(50) not null,
    firstName varchar(50) not null,
    extension varchar(10) not null,
    email varchar(100) not null,
    officeCode varchar(10) not null,
    reportsTo int(11),
    jobTitle varchar(50) not null,
    deletedAt TIMESTAMP DEFAULT NOW()
);
DELIMITER $$
DROP TRIGGER IF EXISTS before_employee_delete;
CREATE TRIGGER before_employee_delete
    BEFORE DELETE
    ON employees
    FOR EACH ROW
BEGIN
    INSERT INTO exEmployees(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
    VALUES (OLD.employeeNumber, OLD.lastName, OLD.firstName, OLD.extension, OLD.email, OLD.officeCode, OLD.reportsTo, OLD.jobTitle);
END$$

DELIMITER ;

--3 LOG PRODUCTO INSERT

use classicmodels;
drop table if exists logProducts;
create table logProducts(
id int auto_increment,
productCode VARCHAR(15),
dateLog TIMESTAMP DEFAULT NOW(),
descripcion VARCHAR(500) NOT NULL,
PRIMARY KEY (id, productCode));



DELIMITER $$
DROP TRIGGER IF EXISTS after_inserts_products;
create trigger after_inserts_products
after insert on products
for each row
Begin
		INSERT INTO logProducts(productCode, descripcion)
        VALUES (new.productCode, CONCAT('Se ha insertado un nuevo producto: ', NEW.productName));
End$$
DELIMITER ; 

INSERT INTO products(productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP)
VALUES("S66_6969","Bugatti Test","Sport Cars",1:72,"Dubai AutoSports","Created in Dubai",200,52.20,60.30);

INSERT INTO products(productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP)
VALUES("S66_7777","Falcon X Test","Sport Cars",1:72,"Dubai AutoSports","Created in Dubai",7,250.25,260.30);
SELECT * FROM classicmodels. logProducts;



-- 3 LOG PRODUCT UPDATE
DELIMITER //
DROP TRIGGER IF EXISTS after_update_products;
CREATE TRIGGER after_update_products
AFTER UPDATE  ON products FOR EACH ROW
Begin
        IF NEW.productName <> OLD.productName THEN
		INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de nombre: ', OLD.productName, ' a ' , NEW.productName ));

		ELSEIF  NEW.productLine <> OLD.productLine THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de productLine: ', OLD.productLine, ' a ' , NEW.productLine ));

    	ELSEIF  NEW.productScale <> OLD.productScale THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de productLine: ', OLD.productScale, ' a ' , NEW.productScale ));

    	ELSEIF  NEW.productVendor <> OLD.productVendor THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de productVendor: ', OLD.productVendor, ' a ' , NEW.productVendor ));

    	ELSEIF  NEW.productDescription <> OLD.productDescription THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de productDescription: ', OLD.productDescription, ' a ' , NEW.productDescription ));

    	ELSEIF  NEW.quantityInStock <> OLD.quantityInStock THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de quantityInStock: ', OLD.quantityInStock, ' a ' , NEW.quantityInStock ));

    	ELSEIF  NEW.buyPrice <> OLD.buyPrice THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de buyPrice: ', OLD.buyPrice, ' a ' , NEW.buyPrice ));

    	ELSEIF  NEW.MSRP <> OLD.MSRP THEN
    	INSERT INTO logProducts(productCode, descripcion)
		VALUES (OLD.productCode, CONCAT('Actualizacion de MSRP: ', OLD.MSRP, ' a ' , NEW.MSRP ));

		END IF;
End//
DELIMITER ;

UPDATE products
SET buyPrice = 100.20
WHERE productCode = 'S66_6969';







-- 4 IMPEDIR DELETE 
use classicmodels;
DELIMITER $$
DROP TRIGGER IF EXISTS Before_delete_order;
CREATE TRIGGER Before_delete_order
   BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
   If Old.orderNumber is not null then
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'No puede eliminar este registro de la tabla orders';
End If;
END$$
DELIMITER ;


DELIMITER $$
DROP TRIGGER IF EXISTS Before_delete_payments;
CREATE TRIGGER Before_delete_payments
   BEFORE DELETE ON payments
FOR EACH ROW
BEGIN
   If Old.checkNumber is not null then
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'No puede eliminar este registro de la tabla payments';
End If;
END$$
DELIMITER ;


--4 Registrar Cambios en Ordes
use classicmodels;
drop table if exists logOrders;
create table logOrders(
id int auto_increment,
orderNumber int,
dateLog TIMESTAMP DEFAULT NOW(),
descripcion VARCHAR(500) NOT NULL,
PRIMARY KEY (id, orderNumber));

DELIMITER //
DROP TRIGGER IF EXISTS after_update_orders;
CREATE TRIGGER after_update_orders
AFTER UPDATE  ON orders FOR EACH ROW
Begin
        IF NEW.orderNumber <> OLD.orderNumber THEN
		INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de orderNumber: ', OLD.orderNumber, ' a ' , NEW.orderNumber ));

		ELSEIF  NEW.orderDate <> OLD.orderDate THEN
    	INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de orderDate: ', OLD.orderDate, ' a ' , NEW.orderDate ));

    	ELSEIF  NEW.requiredDate <> OLD.requiredDate THEN
    	INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de requiredDate: ', OLD.requiredDate, ' a ' , NEW.requiredDate ));

    	ELSEIF  NEW.shippedDate <> OLD.shippedDate THEN
    	INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de shippedDate: ', OLD.shippedDate, ' a ' , NEW.shippedDate ));

    	ELSEIF  NEW.status <> OLD.status THEN
    	INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de status: ', OLD.status, ' a ' , NEW.status ));

    	ELSEIF  NEW.comments <> OLD.comments THEN
    	INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de comments: ', OLD.comments, ' a ' , NEW.comments ));

    	ELSEIF  NEW.customerNumber <> OLD.customerNumber THEN
    	INSERT INTO logOrders(orderNumber, descripcion)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de customerNumber: ', OLD.customerNumber, ' a ' , NEW.customerNumber ));


		END IF;
End//
DELIMITER ;


--4 Registar cambios en payments
use classicmodels;
drop table if exists logPayments;
create table logPayments(
id int auto_increment,
checkNumber    varchar(50)    not null,
dateLog TIMESTAMP DEFAULT NOW(),
descripcion VARCHAR(500) NOT NULL,
PRIMARY KEY (id, checkNumber));

DELIMITER //
DROP TRIGGER IF EXISTS after_update_payments;
CREATE TRIGGER after_update_payments
AFTER UPDATE  ON payments FOR EACH ROW
Begin
        IF NEW.checkNumber <> OLD.checkNumber THEN
		INSERT INTO logPayments(checkNumber, descripcion)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de orderNumber: ', OLD.checkNumber, ' a ' , NEW.checkNumber ));

		ELSEIF  NEW.customerNumber <> OLD.customerNumber THEN
    	INSERT INTO logPayments(checkNumber, descripcion)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de customerNumber: ', OLD.customerNumber, ' a ' , NEW.customerNumber ));

    	ELSEIF  NEW.paymentDate <> OLD.paymentDate THEN
    	INSERT INTO logPayments(checkNumber, descripcion)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de paymentDate: ', OLD.paymentDate, ' a ' , NEW.paymentDate ));

    	ELSEIF  NEW.amount <> OLD.amount THEN
    	INSERT INTO logPayments(checkNumber, descripcion)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de amount: ', OLD.amount, ' a ' , NEW.amount ));

		END IF;
End//
DELIMITER ;


--4 REGISTRAR EMPLEADO QUE HACE CAMBIOS EN ORDERS
SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = 10111;

use classicmodels;
drop table if exists logOrders;
create table logOrders(
id int auto_increment,
orderNumber int,
dateLog TIMESTAMP DEFAULT NOW(),
descripcion VARCHAR(500) NOT NULL,
employesLog VARCHAR(50),
PRIMARY KEY (id, orderNumber));

DELIMITER //
DROP TRIGGER IF EXISTS after_update_orders;
CREATE TRIGGER after_update_orders
AFTER UPDATE  ON orders FOR EACH ROW
Begin
        IF NEW.orderNumber <> OLD.orderNumber THEN
		INSERT INTO logOrders(orderNumber, descripcion, employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de orderNumber: ', OLD.orderNumber, ' a ' , NEW.orderNumber ),
		        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber));

		ELSEIF  NEW.orderDate <> OLD.orderDate THEN
    	INSERT INTO logOrders(orderNumber, descripcion, employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de orderDate: ', OLD.orderDate, ' a ' , NEW.orderDate ),
		        		        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber));

    	ELSEIF  NEW.requiredDate <> OLD.requiredDate THEN
    	INSERT INTO logOrders(orderNumber, descripcion, employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de requiredDate: ', OLD.requiredDate, ' a ' , NEW.requiredDate ),
			        		        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber)
		);

    	ELSEIF  NEW.shippedDate <> OLD.shippedDate THEN
    	INSERT INTO logOrders(orderNumber, descripcion, employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de shippedDate: ', OLD.shippedDate, ' a ' , NEW.shippedDate ),
     		        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                    AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber)

		);

    	ELSEIF  NEW.status <> OLD.status THEN
    	INSERT INTO logOrders(orderNumber, descripcion, employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de status: ', OLD.status, ' a ' , NEW.status ),
		            	        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber)

		);

    	ELSEIF  NEW.comments <> OLD.comments THEN
    	INSERT INTO logOrders(orderNumber, descripcion, employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de comments: ', OLD.comments, ' a ' , NEW.comments ),
		            	        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber)
		);

    	ELSEIF  NEW.customerNumber <> OLD.customerNumber THEN
    	INSERT INTO logOrders(orderNumber, descripcion,employesLog)
		VALUES (OLD.orderNumber, CONCAT('Actualizacion de customerNumber: ', OLD.customerNumber, ' a ' , NEW.customerNumber ),
			        		        (SELECT lastName FROM employees, customers, orders WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND orders.customerNumber = customers.customerNumber AND orders.orderNumber = OLD.orderNumber)
		);


		END IF;
End//
DELIMITER ;


--4 REGISTRA EMPLEADO QUE HACE CAMBIOS EN PAYMENTS

SELECT lastName FROM employees, customers, payments WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND payments.customerNumber = customers.customerNumber AND payments.checkNumber = 'HQ336336';


use classicmodels;
drop table if exists logPayments;
create table logPayments(
id int auto_increment,
checkNumber    varchar(50)    not null,
dateLog TIMESTAMP DEFAULT NOW(),
descripcion VARCHAR(500) NOT NULL,
employesLog VARCHAR(50),
PRIMARY KEY (id, checkNumber));

DELIMITER //
DROP TRIGGER IF EXISTS after_update_payments;
CREATE TRIGGER after_update_payments
AFTER UPDATE  ON payments FOR EACH ROW
Begin
        IF NEW.checkNumber <> OLD.checkNumber THEN
		INSERT INTO logPayments(checkNumber, descripcion,employesLog)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de orderNumber: ', OLD.checkNumber, ' a ' , NEW.checkNumber ),
		        (SELECT lastName FROM employees, customers, payments WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND payments.customerNumber = customers.customerNumber AND payments.checkNumber = OLD.checkNumber
                ));

		ELSEIF  NEW.customerNumber <> OLD.customerNumber THEN
    	INSERT INTO logPayments(checkNumber, descripcion, employesLog)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de customerNumber: ', OLD.customerNumber, ' a ' , NEW.customerNumber ),
		        		        (SELECT lastName FROM employees, customers, payments WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                    AND payments.customerNumber = customers.customerNumber AND payments.checkNumber = OLD.checkNumber
                )

		        );

    	ELSEIF  NEW.paymentDate <> OLD.paymentDate THEN
    	INSERT INTO logPayments(checkNumber, descripcion, employesLog)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de paymentDate: ', OLD.paymentDate, ' a ' , NEW.paymentDate ),
		        (SELECT lastName FROM employees, customers, payments WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                                                  AND payments.customerNumber = customers.customerNumber AND payments.checkNumber = OLD.checkNumber
                )
		        );

    	ELSEIF  NEW.amount <> OLD.amount THEN
    	INSERT INTO logPayments(checkNumber, descripcion, employesLog)
		VALUES (OLD.checkNumber, CONCAT('Actualizacion de amount: ', OLD.amount, ' a ' , NEW.amount ),
		        		    (SELECT lastName FROM employees, customers, payments WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
                             AND payments.customerNumber = customers.customerNumber AND payments.checkNumber = OLD.checkNumber
                ));

		END IF;
End//
DELIMITER ;