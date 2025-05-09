/*Repaso Cursores*/
/*Ej1*/
delimiter //
create procedure actualizarStock() begin
	declare salir boolean default 0;
    declare stock_c int default 0;
    declare cod_c int default 0;
	declare cursorActualizarStock cursor for select Producto_codProducto, sum(cantidad) from ingresostock_producto join ingresostock on IngresoStock_idIngreso=idIngreso where fecha>=current_date()-interval 7 Day group by Producto_codProducto;
    declare continue handler for not found set salir=1;
    open cursorActualizarStock;
    bucle:loop
    fetch cursorActualizarStock into cod_c, stock_c;
    if salir=1 then
		leave bucle;
	end if;
	update producto set stock=stock_c where codProducto=cod_c;
    end loop bucle;
    close cursorActualizarStock;
end//
delimiter ;

call actualizarStock();
drop procedure actualizarStock;

/*2*/
delimiter //
create procedure actualizarPrecioProductoPorVentas() begin
	declare salir boolean default 0;
	declare cod_c int default 0;
    declare cursorObtenerCodigo cursor for select Producto_codProducto from pedido_producto join pedido on Pedido_idPedido=idPedido where fecha>=current_date()-interval 7 Day group by Producto_codProducto having sum(cantidad) < 100;
    declare continue handler for not found set salir=1;
    open cursorObtenerCodigo;
    bucle:loop
    fetch cursorObtenerCodigo into cod_c;
    if salir then
		leave bucle;
	end if;
	update producto set precio=precio*0.90 where codProducto=cod_c;
    end loop bucle;
end//
delimiter ;

call actualizarPrecioProductoPorVentas();
drop procedure actualizarPrecioProductoPorVentas;

/*3*/
delimiter //
create procedure actualizarPrecioProductoPorProveedor() begin
	declare salir boolean default 0;
    declare cod_c int default 0;
    declare precio_c float default 0;
    declare cursorCodigoPrecio cursor for select Producto_codProducto, max(precio) from producto_proveedor group by Producto_codProducto;
    declare continue handler for not found set salir = 1;
    open cursorCodigoPrecio;
    bucle:loop
    fetch cursorCodigoPrecio into cod_c, precio_c;
    if salir then
		leave bucle;
	end if;
	update producto set precio=precio_c*1.10 where codProducto=cod_c;
    end loop bucle;
end //
delimiter ;

call actualizarPrecioProductoPorProveedor();

/*4*/
delimiter //
create procedure actualizarNivelProveedor() begin
	declare salir boolean default 0;
    declare cod_c int default 0;
    declare cantidad int default 0;
	declare cursorCodigoProveedor cursor for select Proveedor_idProveedor, sum(cantidad) from ingresostock join ingresostock_producto on idIngreso=IngresoStock_idIngreso where fecha >= current_date() - interval 2 Month group by Proveedor_idProveedor;
    declare continue handler for not found set salir=1;
    open cursorCodigoProveedor;
    bucle:loop
	fetch cursorCodigoProveedor into cod_c, cantidad;
    if salir then
		leave bucle;
	end if;
	if cantidad > 100 then
		update proveedor set nivel = "Oro" where idProveedor=cod_c;
	elseif cantidad between 50 and 100 then
		update proveedor set nivel = "Plata" where idProveedor=cod_c;
	else
		update proveedor set nivel = "Bronce" where idProveedor=cod_c;
	end if;
    end loop bucle;
end//
delimiter ;

call actualizarNivelProveedor();

/*5*/
delimiter //
create procedure actualizarProductoPendientePago() begin
	declare salir boolean default 0;
    declare precio_actual float default 0;
    declare cod_c int default 0;
    declare cursorCodigoProducto cursor for select distinct (Producto_codProducto) from pedido_producto join pedido on Pedido_idPedido=idPedido where Estado_idEstado=1;
    declare continue handler for not found set salir=1;
    open cursorCodigoProducto;
    bucle:loop
    fetch cursorCodigoProducto into cod_c;
    if salir then
		leave bucle;
	end if;
    select precio into precio_actual from producto where codProducto=cod_c;
    update pedido_producto set precioUnitario=precio_actual where Producto_codProducto=cod_c;
    end loop bucle;
    close cursorCodigoProducto;
end//
delimiter ;

call actualizarProductoPendientePago();
drop procedure actualizarProductoPendientePago;
