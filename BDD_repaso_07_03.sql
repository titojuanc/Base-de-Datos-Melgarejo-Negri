/*1*/
SELECT nombre FROM proveedor WHERE ciudad="La Plata";

/*2*/
Delete from articulo where codigo in (Select articulo_codigo from compuesto_por where material_codigo is null);

/*3*/
SELECT articulo.descripcion, articulo.codigo FROM articulo JOIN compuesto_por on articulo_codigo=articulo.codigo JOIN provisto_por on compuesto_por.material_codigo=provisto_por.material_codigo JOIN proveedor on provisto_por.proveedor_codigo=proveedor.codigo WHERE proveedor.nombre= "Lopez SA";

/*4*/
Select proveedor.codigo, proveedor.nombre from proveedor join provisto_por on proveedor.codigo=proveedor_codigo join material on provisto_por.material_codigo=material.codigo join compuesto_por on material.codigo=compuesto_por.material_codigo join articulo on compuesto_por.articulo_codigo=articulo.codigo where articulo.precio > 10000;

/*5*/
select codigo, descripcion from articulo where precio =(select max(precio) from articulo);

/*6*/
Select articulo.descripcion from articulo join tiene on articulo.codigo=tiene.articulo_codigo group by(articulo_codigo) order by sum(stock) desc limit 1;

/*7*/
SELECT almacen_codigo FROM articulo JOIN compuesto_por on articulo.codigo=compuesto_por.articulo_codigo JOIN tiene on articulo.codigo=tiene.articulo_codigo WHERE material_codigo=2 group by(almacen_codigo); 

/*8*/
select articulo.descripcion from articulo where articulo.codigo = (select articulo_codigo from compuesto_por group by (articulo_codigo) order by count(material_codigo) desc limit 1);

/*9*/
update articulo join tiene on articulo.codigo=articulo_codigo set precio=precio + precio*0.2 where stock < 20; 

/*10*/
select avg(prom) from (select count(articulo_codigo) as prom from compuesto_por group by (articulo_codigo)) as c;

/*11*/
select min(precio), max(precio), avg(precio) from articulo join tiene on articulo.codigo=tiene.articulo_codigo group by(almacen_codigo);

/*12*/
SELECT almacen_codigo, sum(articulo.precio*stock) FROM tiene JOIN articulo ON articulo.codigo=articulo_codigo GROUP BY almacen_codigo;

/*13*/
Select articulo.precio*stock from articulo join tiene on articulo.codigo=tiene.articulo_codigo where stock > 100;

/*14*/
SELECT articulo.codigo, precio from articulo join compuesto_por on articulo.codigo=articulo_codigo where precio>5000 and codigo in (select articulo_codigo from compuesto_por group by (articulo_codigo) having (count(material_codigo)>3) order by count(material_codigo));

/*15*/
Select material.descripcion from material join compuesto_por on material.codigo=compuesto_por.material_codigo join articulo on compuesto_por.articulo_codigo=articulo.codigo where precio > (select avg(precio) from articulo join tiene on articulo.codigo=tiene.articulo_codigo where almacen_codigo=2 group by(almacen_codigo));