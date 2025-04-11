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

/*9*////

delimiter //
create procedure CiudadesConOFicinas(out ciudades varchar(4000))
begin
	
	declare hayFilas boolean default 1;
	declare ciudadActual varchar(45);
    declare cursorCiudades cursor for select distinct(city) from offices;
    declare continue handler for not found set hayFilas=0;
    open cursorCiudades;
    set ciudades="";
    bucle:loop
		fetch cursorCiudades into ciudadActual;
        if (NOT hayFilas) then
			leave bucle;
		end if;
        set ciudades= concat(ciudadActual, ", ", ciudades);
	end loop bucle;

    close cursorCiudades;
end//
delimiter ;

drop procedure CiudadesConOficinas;
set @ciudadesConOficinas="";
call CiudadesConOficinas(@ciudadesConOficinas);
select @ciudadesConOFicinas;

/*Ej 10*/
create table CancelledOrders(
	orderNumber int primary key,
    orderDate date,
    shippedDate date,
    customerNumber int,
    foreign key (customerNumber) References customers (customerNumber)
);
 
delimiter //
create procedure insertCancelledOrders(out ordenesCanceladas int)
begin
	declare salir boolean default 0;
    declare num, cnum int default 0;
    declare orderD, shippedD date;
    declare cursorOrders cursor for select orderNumber, orderDate, shippedDate, customerNumber from orders where status="Cancelled";
    declare continue handler for not found set salir=1;
    open cursorOrders;
    recorrer:loop
		fetch cursorOrders into num, orderD, shippedD, cnum;
        if salir=1 then
			leave recorrer;
		end if;
		insert into CancelledOrders (orderNumber, orderDate, shippedDate, customerNumber) values(num, orderD, shippedD, cnum);
	end loop recorrer;
    close cursorOrders;
    select count(*) into ordenesCanceladas from CancelledOrders;
end//
delimiter ;
 
call insertCancelledOrders(@ordenesCanceladas);
select @ordenesCanceladas;
 
drop procedure insertCancelledOrders;
drop table CancelledOrders;

/*11*/
delimiter //
create procedure anotarTotal(in cliente int)
begin
	declare hayFilas boolean default 1;
	declare descripcionActual text;
    declare precioActual float;
    declare ordenActual int;
    declare cursorOrdenes cursor for select comments, sum(quantityOrdered*priceEach), orders.orderNumber from orders join orderdetails on orders.orderNumber=orderdetails.orderNumber where customerNumber=cliente group by(orderNumber);
	declare continue handler for not found set hayFilas=0;
    open cursorOrdenes;
    bucle:loop
		fetch cursorOrdenes into descripcionActual, precioActual, ordenActual;
        if(NOT hayFilas) then
			leave bucle;
		end if;
        if (descripcionActual is null) then
			update orders set comments=concat("El total de la orden es ", precioActual) where orderNumber=ordenActual;
		end if;
	end loop bucle;
    close cursorOrdenes;
end//
delimiter ;

drop procedure anotarTotal;
call anotarTotal(121);

select sum(priceEach*quantityOrdered), salesRepEmployeeNumber from customers join orders on customers.customerNumber=orders.customerNumber join orderdetails on orders.orderNumber=orderdetails.orderNumber group by (salesRepEmployeeNumber);

/*Ej 12*/
delimiter //
create procedure telefonosClientesOrdenesCanceladas(out num int, out telefono varchar(45), out lista text)
begin
	declare salir boolean default 0;
    declare ultimaFecha, telUltimaFecha date;
	declare cursorClientesOrdenesCanceladas cursor for select orders.customerNumber, phone, max(shippedDate) from customers join orders on customers.customerNumber=orders.customerNumber where status="Cancelled" group by orders.customerNumber;
	declare continue handler for not found set salir=1;
    select max(shippedDate) into ultimaFecha from orders where status="Shipped";
    open cursorClientesOrdenesCanceladas;
    recorrer:loop
		fetch cursorClientesOrdenesCanceladas into num, telefono, telUltimaFecha;
        if salir=1 then
			leave recorrer;
		end if;
        if telUltimaFecha>ultimaFecha then
			set lista = concatws(",", num, telefono, telUltimaFecha, lista);
        end if;
	end loop recorrer;
    close cursorClientesOrdenesCanceladas;
end//
delimiter ;
call telefonosClientesOrdenesCanceladas(@num, @telefono, @lista);
select @num, @telefono, @lista;
 
drop procedure telefonosClientesOrdenesCanceladas;

/*13*/
alter table employees
add commission text;

delimiter //
create procedure cargarComision()
begin
	declare hayFilas boolean default 1;
    declare empleadoActual int;
    declare ventasEmpleado float;
    declare cursorCliente cursor for select sum(priceEach*quantityOrdered), salesRepEmployeeNumber from customers join orders on customers.customerNumber=orders.customerNumber join orderdetails on orders.orderNumber=orderdetails.orderNumber group by (salesRepEmployeeNumber);
    declare continue handler for not found set hayFilas=0;
	open cursorCliente;
    bucle:loop
		fetch cursorCliente into ventasEmpleado, empleadoActual;
		if (NOT hayFilas) then
			LEAVE bucle;
		end if;
        if ventasEmpleado > 100000 then
			update employees set commission="5%" where employeeNumber=empleadoActual;
		elseif ventasEmpleado between 50000 and 100000 then
			update employees set commission="3%" where employeeNumber=empleadoActual;
		elseif ventasEmpleado < 50000 then
			update employees set commission="0%" where employeeNumber=empleadoActual;
        end if;
	end loop bucle;
    close cursorCliente;
end//

call cargarComision();

