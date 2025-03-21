/*1*/
delimiter //
create procedure MayorPrecioProm(out cant int)
begin
	select avg(buyPrice) from products;
    set cant=(select count(*) from products where buyPrice > (select avg(buyPrice)from products));
    select * from products where buyPrice > (select avg(buyPrice) from products);
end//
delimiter ;
drop procedure MayorPrecioProm;

set @cant=0;
call MayorPrecioProm(@cant);
select @cant;

/*2*/
delimiter //
create procedure Ej2_P(out result_2 int, in orden int)
begin
	declare aux int default 0;
	select sum(quantityOrdered) into result_2 from orderdetails where orderNumber=orden;
	if result_2!=0 then
		delete from orderdetails where orderNumber=orden;
        delete from orders where orderNumber=orden;
	end if;
end//
delimiter ;
call Ej2_P(@result_2, 10100);
select @result_2;

/*3*/
	/*4*/
	delimiter //
	create function cantProductLine (producto varchar(45))returns int deterministic
	begin
		declare productoLinea int default 0;
		select count(*) into productoLinea from productlines where productLine=producto;
		return productoLinea;
	end //
	delimiter ;
	select cantProductLine("Classic Cars");

delimiter //
create procedure borrarLinea (in linea varchar(45), out msg text)
begin
	if cantProductLine(linea)=0 then
		delete from productlines where productLine=linea;
        set msg="La línea de productos fue borrada";
    else
		set msg="La línea de productos no pudo borrarse porque contiene productos asociados.";
	end if;
end//
delimiter ;

set @mensaje="";
call borrarLinea("Classic Cars", @mensaje);
select @mensaje;

/*Ej4*/
delimiter //
create procedure Ej4_P()
begin
	select status, count(*) from orders group by status;
end//
delimiter ;
call Ej4_P();
drop procedure Ej4_P;
 
/*5*/
delimiter //
create procedure genteACargo()
begin
	select reportsTo as Jefe, count(*) as "Personas a cargo" from employees group by (reportsTo); 
end//

call genteACargo();

/*Ej6*/
delimiter //
create procedure Ej6_P()
begin
    select orderNumber, sum(priceEach*quantityOrdered) from orderdetails group by(orderNumber);
end//
delimiter ;
call Ej6_P();
drop procedure Ej6_P;

/*7*/
delimiter//
create procedure listarOrdenes()
begin
	select customers.customerNumber, customerName, orders.orderNumber, quantityOrdered*priceEach from customers join orders on customers.customerNumber=orders.customerNumber join orderdetails on orders.orderNumber=orderdetails.orderNumber order by (quantityOrdered*priceEach) desc;  
end//
delimiter ;
drop procedure listarOrdenes;
call list listarOrdenes();

/*Ej8*/
delimiter //
create procedure Ej8(out ej8_1 int, in orden int, in coment text)
begin
	select count(*) into ej8_1 from orders where orderNumber=orden;
    if ej8_1 != 0 then
		update orders set comments = coment where orderNumber=orden;
        set ej8_1=1;
        select ej8_1;
	else
		select ej8_1;
	end if;
end//
delimiter ;
call Ej8(@ej8_1, 10102, "Tito");
	