/*1*/
delimiter //
create procedure actualizarEstado()
begin
	update orders set status = "Delayed" where shippedDate < current_date() and status = "In Process";
end//

delimiter //
create event nombre on schedule every 1 DAY starts now() do
begin
	call actualiazarEstado();
end//

/*2*/
delimiter //
create event eliminarPagos on schedule every 1 month starts now() do
begin
	delete from payments where paymentDate < current_date()-interval 5 year;
end//
delimiter ;

/*3*/
delimiter //
create procedure agregarCredito()
begin
	update customers set creditLimit = creditLimit*1.1 where customerNumber in (select customerNumber from orders where orderDate>current_date()-interval 1 year group by customerNumber having (count(*)>10));
end//

delimiter //
create event creditoMensual on schedule every 1 month starts now() ends now()+interval 1 year do
begin 
	call agregarCredito();
end//

/*4*/
delimiter //
create event pagosPendientes on schedule every 1 week starts timestamp(current_date() + interval 1 day + interval 7 hour) do
begin
	update payments set checkNumber = "Confirmed" where checkNumber is null and paymentDate < current_date()-interval 7 day;
end //
delimiter ;

/*5*/
create table report(
	reportID int primary key,
    reportDate date,
    totalSells int
    );
//

delimiter //
create procedure reporteDiario()
begin
	declare ventas int; 
	select count(*) into ventas from orders where shippedDate = current_date() and status="Shipped";
	INSERT INTO report values (current_date(),ventas);
end//

delimiter //
create event creacionReporteDiario on schedule every 1 day starts now() ends now()+interval 3 month do /*suponiendo que se ejecuta un día a las 23:59*/
begin
	call reporteDiario();
end//

/*6*/
delimiter //
create event actualizarPrecioProductos on schedule every 6 month starts "2025-07-01" do 
begin
	update products join orderdetails on products.productCode = orderdetails.productCode set buyPrice=buyPrice-(buyPrice*0.05) where orderdetails.productCode not in (select productCode from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber where shippedDate > current_date()-interval 2 month and status = "Shipped");
end//
delimiter ; 