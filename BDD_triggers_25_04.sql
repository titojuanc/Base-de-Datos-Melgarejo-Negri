/*1*/
create table customers_audit (
	IdAudit int auto_increment not null primary key,
    Operacion char(6),
    Usuario text,
    Last_date_modified date,
    customerNumber int,
    customerName text,
    phone text
);

delimiter //
create trigger after_customer_insert after insert on customers
for each row
begin
	insert into customers_audit values (null, "insert", current_user(), current_date(), new.customerNumber, new.customerName, new.phone);
end//
delimiter ;

delimiter //
create trigger before_customer_update before update on customers
for each row
begin
	insert into customers_audit values (null, "update", current_user(), current_date(), old.customerNumber, old.customerName, old.phone);
end//
delimiter ;

delimiter //
create trigger before_customer_delete before delete on customers
for each row
begin
	insert into customers_audit values (null, "delete", current_user(), current_date(), old.customerNumber, old.customerName, old.phone);
end//
delimiter ;

/*2*/
create table employees_audit (
	IdAudit int auto_increment not null primary key,
    Operacion char(6),
    Usuario text,
    Last_date_modified date,
    employeeNumber int,
    firstName text,
    email text
);

delimiter //
create trigger after_employees_insert after insert on employees
for each row
begin
	insert into employees_audit values (null, "insert", current_user(), current_date(), new.employeeNumber, new.firstName, new.email);
end//
delimiter ;

delimiter //
create trigger before_employees_update before update on employees
for each row
begin
	insert into employees_audit values (null, "update", current_user(), current_date(), old.employeeNumber, old.firstName, old.email);
end//
delimiter ;

delimiter //
create trigger before_employees_delete before delete on employees
for each row
begin
	insert into employees_audit values (null, "delete", current_user(), current_date(), old.employeeNumber, old.firstName, old.email);
end//
delimiter ;

/*3*/

delimiter //
create trigger before_product_delete before delete on products
for each row
begin
    if (select productCode from orderdetails 
		join orders on orderdetails.orderNumber=orders.orderNumber 
		where orderdetails.productCode=old.productCode and
        orderdetails.orderdate < current_date() - interval 2 month )
	then
		signal sqlstate "45000" set message_text= "Error: el producto está pedido hace menos de 2 meses";
	end if;
end//
delimiter ;
    


	
