/*1*/

delimiter //
create procedure ActualizarStockSemanal ()
begin
	declare hayFilas boolean default 1;
    declare continue handler for not found set hayFilas=0;
    declare itemActual int;
    declare cantidadActual int;
    declare fechaActual datetime;
    declare ingresos cursor for select fecha, Producto_codProducto, cantidad from ingresostock 
								join ingresostock_producto on idIngreso=IngresoStock_idIngreso;
	declare semanaAtras datetime;
    set semanaAtras = current_date() - interval 1 week;
    open ingresos;
    bucle:loop
		fetch ingresos into fechaActual, itemActual, cantidadActual;
        if (NOT hayFilas) then
			leave bucle;
		end if;
        if(fechaActual>semanaAtras) then
			update producto set stock = stock + cantidadActual where codProducto = itemActual;
		end if;
	end loop bucle;
    close ingresos;
end//
delimiter ;

/*2*/
delimiter //
create procedure reducirCostos ()
begin
	declare hayFilas boolean default 1;
    declare continue handler for not found set hayFilas=0;
    declare porductoActual int;
    declare unidadesVendidas int;
    declare cursorPedidos cursor for select Producto_codProducto, sum(cantidad) 
									 from pedido join pedido_producto on
                                     Pedido_idPedido=idPedido 
                                     where fecha>current_date() - interval 1 week
                                     group by(Producto_codProducto);
    open cursorPedidos;
    bucle:loop
		fetch cursorPedidos into productoActual, unidadesVendidas;
        if(NOT hayFilas) then
			leave bucle;
		end if;
        if(unidadesVendidas<100) then
			update producto set precio = precio - precio*0.1 
							where codProducto=productoActual;
		end if;
	end loop bucle;
    close cursorPedidos;
end//
delimiter ;

/*3*/

delimiter //
create procedure ActualizarPrecios()
begin
	declare hayFilas boolean default 1;
    declare continue handler for not found set hayFilas=0;
    declare precioProveedor decimal;
    declare productoActual int;
    declare cursorProveedor cursor for select Producto_codProducto, max(precio) 
									   from producto_proveedor 
                                       group by (Producto_codProducto);
    open cursorProveedor;
    bucle:loop
		fetch cursorProveedor into productoActual, precioProveedor;
		if(NOT hayFilas) then
			leave bucle;
		end if;
			update producto set precio = precioProveedor*1.1 where codProducto=productoActual;
	end loop bucle;
    close cursorProveedor;
end//
delimiter ;

/*4*/

delimiter //
create procedure actualizarNivel()
begin
	declare hayFilas boolean default 1;
    declare continue handler for not found set hayFilas=0;
    declare proveedorActual int;
    declare ventasActuales int;
    declare cursorIngresos cursor for select Proveedor_idProveedor, sum(cantidad) 
									  from ingresostock join ingresostock_producto 
                                      on idIngreso = IngresoStock_idIngreso
                                      where fecha>current_date() - interval 2 month
                                      group by (Proveedor_idProveedor);
	open cursorIngresos;
    bucle:loop
    fetch cursorIngresos into proveedorActual, ventasActuales;
		if (!HayFilas) then
			leave bucle;
		end if;
        if (ventasActuales <= 50) then
            update proveedor set nivel = "Bronce" where idProveedor = proveedorActual;
        elseif (ventasActuales <= 100) then
            update proveedor set nivel = "Plata" where idProveedor = proveedorActual;
        else
            update proveedor set nivel = "Oro" where idProveedor = proveedorActual;
        end if;
	end loop bucle;
end//
delimiter ; 
        
/*5*/

delimiter //
create procedure cambiarPrecioProductosPendientes()
begin
	declare hayFilas boolean default 1;
    declare continue handler for not found set hayFilas=0;
    declare pedidoActual int;
    declare cursorPedido cursor for select idPedido from pedido where Estado_idEstado=2;
    open cursorPedido;
    bucle:loop
		fetch cursorPedido into pedidoActual;
        if (!HayFilas) then
			leave bucle;
		end if;
        update pedido_producto join producto on codProducto=Producto_codProducto set precioUnitario = precio 
        where Pedido_idPedido = pedidoActual;
	end loop bucle;
    close cursorPedido;
end//
		
    
    
	
	
        
			
        
    
	

        
    
    
