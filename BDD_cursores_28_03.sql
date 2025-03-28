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

