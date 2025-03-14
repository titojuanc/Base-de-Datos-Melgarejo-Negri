/*1*/
delimiter //
create function ordenSegunEstado (estado text,fechaInicio date, fechaFinal date) returns int deterministic
begin
	declare cantidadOrdenes int default 0;
    set cantidadOrdenes = (select count(*) from orders where status = estado and orderDate between fechaInicio and fechaFinal);
    return cantidadOrdenes;
end//
delimiter ;

select ordenSegunEstado ("Cancelled", "2023-10-10", current_date());

/*2*/
delimiter //
create function cantOrdenesRegistradas (fechaUno date, fechaDos date) returns int deterministic 
begin
	declare cantOrdenes int default 0;
    select count(*) into cantOrdenes from orders where shippedDate between fechaUno and fechaDos;
    return cantOrdenes;
end//
delimiter ;
select cantOrdenesRegistradas("2023-04-23","2023-07-07");

/*3*/
delimiter //
create function ciudadCliente (cliente int) returns text deterministic
begin
	declare ciudad varchar(45);
    set ciudad = (select city from customers where customerNumber=cliente);
    return ciudad;
end//
delimiter ;

select ciudadCliente (112);

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

/*5*/
delimiter //
create function clientesPorOficina (numero int) returns int deterministic
begin
	declare cantidad int;
    set cantidad = (select count(*) from employees where officeCode=numero);
    return cantidad;
end //
delimiter ;

select clientesPorOficina(2);

/*6*/
delimiter //
create function cantOfficeCode(codigo int) returns int deterministic
begin
	declare cantCodigos int default 0;
	select count(*) into cantCodigos from offices where officeCode=codigo;
	return cantCodigos;
end//
delimiter ;
select cantOfficeCode(1);

/*7*/
delimiter //
create function profit (orden int, producto varchar(45)) returns float deterministic
begin
    declare precioProd float default 0;
    declare ordenPrecio float default 0;
	select buyPrice into precioProd from products where productCode=producto;
    if exists(select priceEach from orderdetails where orderNumber=orden and productCode=producto) then
		select priceEach into ordenPrecio from orderdetails where orderNumber=orden and productCode=producto;
    else
		return -1; /*en caso de que no exista*/
	end if;
    return ordenPrecio-precioProd;
end//
delimiter ;

select profit(10100, "S20_1749");

/*8*/
delimiter //
create function estadoOrden (orden int) returns int deterministic
begin
	declare estado varchar (45) default "x";
    select status into estado from orders where orderNumber=orden;
    if estado="Cancelled" then
		return -1;
	else
		return 0;
	end if;
end//
delimiter ;
select estadoOrden(10166);

/*9*/
delimiter //
create function primeraOrdenHecha (cliente int) returns date deterministic
begin
	declare fecha date;
    set fecha = (select min(orderDate) from orders where customerNumber=cliente);
    return fecha;
end//
delimiter ;

select primeraOrdenHecha(103);

/*10*/
delimiter //
create function vecesDebajoMSRP (codigo varchar(45)) returns float deterministic
begin
	declare MRSP_v float default 0;
    declare precio_menor int default 0;
    declare precio_encima int default 0;
    select MSRP into MRSP_v from products where productCode=codigo;
    select count(*) into precio_menor from orderdetails where productCode=codigo and priceEach<MRSP_v;
    select count(*) into precio_encima from orderdetails where productCode=codigo;
    return 100*(precio_menor/precio_encima);
end//
delimiter ;
select vecesDebajoMSRP("S18_1749");
drop function vecesDebajoMSRP;

/*11*/
delimiter //
create function ultimaVezPedido (producto varchar(45)) returns date deterministic
begin
	declare fecha date;
    set fecha= (select max(orderDate) from orders join orderdetails on orderdetails.orderNumber=orders.orderNumber where productCode=producto);
    return fecha;
end//
delimiter ;

select ultimaVezPedido("S12_1666");

/*12*/
delimiter //
create function funcion12(fechaUno date, fechaDos date, codigo varchar(45)) returns float deterministic
begin
	if exists (select max(priceEach) from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber where orderDate between fechaUno and fechaDos) then
		return (select max(priceEach) from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber where orderDate between fechaUno and fechaDos);
	else
		return 0;
	end if;
end//
delimiter ;
select funcion12("2003-04-04","2024-12-12","S18_1749");
drop function funcion12;

/*13*/
delimiter //
create function cantClientes (empleado int) returns int deterministic
begin
	declare cantidad int default 0;
    set cantidad = (select count(*) from customers join employees on employeeNumber=salesRepEmployeeNumber where employeeNumber=empleado);
    return cantidad;
end//
delimiter ;

select cantClientes(1370);

/*14*/
delimiter //
create function funcion14(numero int)returns varchar(45) deterministic
begin
	declare apellido varchar(45) default "x";
    select lastName into apellido from employees where numero=employeeNumber;
    return apellido;
end//
delimiter ;
select funcion14("1002");
