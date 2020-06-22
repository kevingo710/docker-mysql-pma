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
descripcion VARCHAR(255) NOT NULL,
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


