/*1*/
delimiter //
create function nivel(empleado int) returns text deterministic
begin
	declare Cant int;
    set Cant = (select count(*) from employees where reportsTo=empleado);
    if Cant>20 then
		return "Nivel 3";
	else if Cant between 20 and 10 then
		return "Nivel 2";
	else
		return "Nivel 1";
	end if;
    end if;
end//

delimiter ;

select nivel(1002);

/*Ej extra 2*/
delimiter //
create function EjExtra2(fechaUno Date, fechaDos Date)returns int deterministic
begin
	return datediff(fechaUno, fechaDos);
end//
delimiter ;
select EjExtra2("2024-04-04", "2024-04-03");

/*3*/
delimiter //
create function cambiarEstado () returns text deterministic
begin
	declare cant_inicial int;
    declare cant_final int;
    set cant_inicial= (select count(*) from orders where status = "Cancelled");
	update orders set status = "Cancelled" where EjExtra2(shippedDate, orderDate)>= 10;
	set cant_final= (select count(*) from orders where status = "Cancelled");
    return cant_final-cant_inicial;
end//
delimiter ;

select cambiarEstado();

/*Ej extra 4*/
delimiter //
create function EjExtra4(codigo_producto varchar (45), orden int)returns int deterministic
begin
	declare cantidad int default 0;
    select quantityOrdered into cantidad from orderdetails where codigo_producto=productCode and orden=orderNumber;
    delete from orderdetails where codigo_producto=productCode and orden=orderNumber;
    if cantidad=0 then
		return -1;
	else
		return cantidad;
	end if;
end//
delimiter ;
select EjExtra4("S18_4409", 10100);
drop function EjExtra4;
	