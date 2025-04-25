/*1*/
delimiter //
create trigger after_pedidoProducto_insert1 after insert on pedido_producto
for each row
begin
	update ingresostock_producto 
    set ingresostock_producto.cantidad = ingresostock_producto.cantidad-new.cantidad 
    where ingresostock_producto.Producto_codProducto = new.Producto_codProducto;
end//
delimiter ;

/*2*/
delimiter //
create trigger before_delete_ingresostock before delete on ingresostock for each row
begin
	delete from ingresostock_producto where IngresoStock_idIngreso=old.idIngreso;
end//
delimiter ;

/*3*/
delimiter //
create trigger after_pedidoProducto_insert2 after insert on pedido
for each row
begin
	declare monto_total int;
    set monto_total =  (select sum(cantidad*precioUnitario) from pedido_producto 
						join pedido on Pedido_idPedido=idPedido
						where Cliente_codliente = new.Cliente_codCliente and
                        fecha > current_date() - interval 2 year );
    if (monto_total <= 50000) then
		update cliente
		set categoria = "bronce"
        where codCliente= new.Cliente_codCliente;
	else if (monto_total > 50000 and monto_total <= 100000 ) then
		update cliente
		set categoria = "plata"
        where codCliente= new.Cliente_codCliente;
	else if (monto_total > 100000) then
		update cliente
		set categoria = "oro"
        where codCliente= new.Cliente_codCliente;
	end if;
end//
delimiter ;

/*4*/
delimiter //
create trigger after_insert_ingresostock_producto after insert on ingresostock_producto for each row
begin
	update producto set stock=stock+new.cantidad where codProducto=new.Producto_codProducto;
end//
delimiter ;

/*5*/

/*Si todas las tablas estuvieran con claves 
foráneas con -on delete no action-, cualquier 
acción de delete será rechazada por el sistema*/

/*Una forma de resolver la problemática de eliminar
 una entrada de pedido, sería eliminando las entradas
 de pedido_producto relacionadas con esta línea a borrar*/ 
 
delimiter //
create trigger before_pedido_delete before delete on pedido
for each row
begin
	update producto join pedido_producto on codProducto=Producto_codProduct set stock =+ pedido_producto.cantidad where pedido_producto.Pedido_idPedido=old.idPedido;
	delete from pedido_producto where Pedido_idPedido=old.idPedido;
end//
delimiter ;

/*Ésta alternativa nos parece la más adecuada, por su simpleza y efectividad.*/


    
    
	