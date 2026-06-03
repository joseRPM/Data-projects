-- 							-------------------------------------------------------------------------------------
-- 							-------------------------------------------------------------------------------------
-- 														 PROYECTO PORTAFOLIO MYSQL
-- 														   	ANALISIS DE VINOS 
-- 							-------------------------------------------------------------------------------------
-- 							-------------------------------------------------------------------------------------
SELECT @@hostname;

CREATE USER 'root'@'%' IDENTIFIED BY 'tu_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

														--  RESUMEN Y CONCLUSIONES --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Si desea evitar revisar todas la querrys en esta seccion se escribiran todas las conclusiones que tengan que ver con este proyecto
--





--



														--  LIMPIEZA DE DATOS --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Primero creamos la base de datos
create database vino; 			 -- Creamos la base de datos
show databases;        			 -- Verificamos que se creo la base de datos
select * from dataset_vinos;     -- Revisamos si se cargo el .csv a la tabla correctamente

-- Al revisar la tabla vemos que los datos se exportaron correctamente, pero, existen datos vacios
-- Para evitar errores de calculo se deberan modificar estas celdas para pasar de ' ' -> null 

-- Corregimos un error sobre la columna 'price' para que su contenido solo sean numeros enteros 
select price						  -- en la colunma precio
from dataset_vinos					  -- con origen en la tabla dataset_vinos
where price not regexp '^[0-9.]+$';   -- donde el contenido no cumpla con ser un numero o un punto (^: inicio del ancla. $: final del ancla)
									  -- si la consulta devuelve nada  la columna en su totalidad es texo y podemos transformar text->int  lo esta!

-- Acontinuacion limpiamos el resto de las columnas del dataset
-- trim() es una herramienta que nos ayuda a eliminar los espacios en las orillas del contenido de las celdas
-- Si despues de ocupar trim obtenemos una celda vacia " " cambiamos su estado a null.
-- Como estamos realizando modificaciones generales a la tabla con un where y no directamente sobre el id (que es irrepetible) desactibaremos el modo seguro

SET SQL_SAFE_UPDATES = 0;             -- Desactivamos el modo seguro para modificar los datos con una sola consulta

alter table dataset_vinos			  -- con esto transformamos correctamente los datos a decimal
modify price decimal(10,2);           -- muchas funciones como avg() ignoran los datos null
									 
update dataset_vinos				  -- Actualizamos la columna price
set price = null
where price = '';                     -- cuando el precio sea vacio lo transformamos a null asi obviarlo y evitar errores de analisis

update dataset_vinos
set designation = null
where trim(designation) = '';

update dataset_vinos
set region_1 = null
where trim(region_1) = '';			

update dataset_vinos
set region_2 = null
where trim(region_2) = '';

update dataset_vinos
set taster_name = null
where trim(taster_name) = ''; 
 
 update dataset_vinos
 set taster_twitter_handle = null
 where trim(taster_twitter_handle) = '';
 
 SET SQL_SAFE_UPDATES = 1;                   						 -- Reactivamos el modo seguro 
 
 alter table tabla2 rename to dataset_vinos;  					   	 -- Se modifico el nombre del dato por comodidad
 alter table dataset_vinos rename column MyUnknownColumn to id; 	 -- Se modifico el nombre del dato por comodidad
 
 select * from dataset_vinos where price = ' ' ;       -- Buscamos todos los registros/vinos donde el precio sea ' '
												       -- No aparece nada por la correcta filtracion de datos. Ahora son elementos nulos
 
 
 
														-- ANLISIS EXPLORATORIO BASICO --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Revisamos el Dataset de forma general
-- Consultas rapidas que brindan informacion util
                           
-- ¿Cuantos registros/vinos tiene el dataset?
select count(*) as total_registros from dataset_vinos; 
select * from dataset_vinos;        							-- Comprobacion visual (Considerar que para datasets con mas datos esto es peligroso)
-- R: 304 registros 

-- ¿Cuantos paises estan participando?                                 
select count(distinct country) as paises from dataset_vinos; 
select
row_number() over(order by country) as indice, country as pais		 -- Le colocamos un indice numerico
from(select distinct country from dataset_vinos) as paises;  		 -- Usamos una tabla deribada  
-- R: Participan 15 paises 

-- ¿Cuantos vinos distintos participan de cada pais?
select country, count(*) as cantidad_vinos                           -- Seleccionamos el pais del vino y  cuantos Vinos tiene ese pais
from dataset_vinos                          						 -- De la tabla dataset_vinos
group by country                           							 -- Agrupamos las filas por paises 
order by cantidad_vinos desc;										 -- Orden decreciente
-- R: Una lista de cada pais junto con la cantidad de vinos diferentes participando

-- ¿Existen elementos nulos en la columna de paises y/o precio?
select count(*) as total_registros, count(country) as country_no_nulo, count(price) as price_no_nulo    -- Revisamos si existen elementos nulos
from dataset_vinos;																						-- Faltan precios 
-- R: Existen 102 elementos null en la columna 'price'

-- ¿Cual es el rango de precios de los vinos?
select min(price) as precio_minimo,max(price) as precio_maximo, round(avg(price),0) as precio_promedio  -- El vino mas barato, caro y el promedio respectivamente
from dataset_vinos;	                                                                                    -- De no hacer la filtracion previa habria aparecido como " " el precio minimo
-- R: precio minimo 9, precio maximo 215, precio promedio de 32.

-- ¿Cual es el rango de puntaje de los vinos?
select min(points) as puntaje_minimo,max(points) as puntaje_maximo  -- El rango de puntos dentro del dataset
from dataset_vinos;	
-- R: El rando de puntos va desde los 85 hasta los 92 puntos



														-- PREGUNTAS DE ANALISIS --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Preguntas un poco mas complejas que respondes preguntas competitivas


-- ¿Cual es el promedio de vinos distintos presentados por pais dentro del dataset?
select avg(cantidad_vinos) as promedio_vinos_por_pais    -- Toma el resultado de la parte interior, lo mira como si fuera una tabla y calcula el promedio 
	from(											     -- from, misma forma de hacer referencia a una tabla
		select count(*) as cantidad_vinos                -- la parte interna agrupa los vinos por pais y cuenta cuantos son
		from dataset_vinos
		group by country)
as conteo_paises;
-- R: El promedio de vinos distintos por pais es de 20

-- ¿que paises tiene los mejores vinos? basandonos en su puntaje promedio y que posean como minimo 20 vinos distintos participando
select country as pais, avg(points) as puntaje_promedio, count(*) as cantidad  		-- tenemos 3 resultados, el pais del vino, su promedio, y cuantos vinos produjo
from dataset_vinos	                                                   				-- origen de la informacion
-- WHERE country IS NOT NULL                                          			    -- para futuras consultas, por si se ingresa un pais sin datos de vinos (filtrar datos sucios)
group by pais                                                     				    -- como se va a agrupar la informacion (todas las filas del mismo pais)
having count(*)>=20                                                   			    --  la cantidad de vinos debe ser minima de 20 para un promedio fiable
order by puntaje_promedio desc;                                        				-- ordena de mayor a menor promedio
-- R: Dadas las condiciones de la consulta se obtiene que francia obtiene un mejor puntaje promedio
-- pero ahora me pregunto ¿como afectara la dispersion del puntaje promedio en cada pais?
--  pais	   puntaje_promedio  Cantidad
--  france	      88.5714		    35
--  Italy	      87.8235		    68		
--  US		      87.8167	    	120

-- ¿Que catadores han evaluado mas vinos? 
select taster_name, count(*) as vinos_catados 
from dataset_vinos
where taster_name is not null                  -- aparece un catador fantasma, quiere decir que en algunos casos no se sabe el nombre del catador
group by taster_name						   -- pero, se dejo como NULL y por eso no aparece
order by vinos_catados desc;
-- R: El catador que probo mas vinos es Roger Voss con un total de 37 vinos catados

-- ¿Cules son los vinos mas baratos? y dentro de estos ¿que vinos son los que poseen mejor puntaje?
select 
    id as N_vino,                   -- id
    country,
    price as precio,
    points as puntaje
from dataset_vinos
where price is not null           -- esta linea  es necesaria,  existen elementos null
and price > 0                     -- Por si acaso, sabemos que los datos estan limpios, es un buen habito
order by price asc, points desc;  -- con esta linea hacemos que aparescan los mas baratos y dentro de los mas baratos muestra los mejor puentuados primero
-- R: El vino numero 138 de origen frances el cual tiene un precio de 10 um (unidad monetaria) con un puntaje de 90 recordando que los mejores vinos
-- tienen un puntaje de 92. Por tanto es una compra excelente

-- ¿Cual es la relacion entre los vinos caros y los puntajes altos?
select 
id as N_vino,       -- Usamos el nombre predefinido del dataset
price as precio,
points as puntaje
from dataset_vinos
where price is not null
and price >0
order by precio desc, puntaje desc;
-- R: Los precios son claramente mayores en comparacion con los vinos mas baratos. Saltamos desde los 9um a vinos sobre los 100um
-- y vemos que su puntaje mas alto llega hasta los 92 puntos en mas de un vino

-- analisis relacion calidad precio
-- dividiremos la muestra en 3 iguales (tambien conocidos como terciles) para comprarar segmentos del mercado (segmentacion por percentiles).

with datos_segmentados as(                    -- creamos una tabla temporal con with no se guarda, existira solamente durante la query
select
	points,
    price,
    ntile(3) over(order by price) as tercil   --  primero ordenanos los precios para despues dividir los datos en 3 grupos iguales. over se interpreta como "sobre"
    from dataset_vinos
    where price is not null
)
select 										  -- hacemos la consulta a la tabla temporal
	case 
		when tercil =1 then '1.Barato'
        when tercil =2 then '2.Intermedio'
        when tercil =3 then '3.Caro'
   end as segmento,                                     -- Nombre a la columna resultante de usar case
   min(price) as precio_min,                            -- Precio minimo por cada grupo
   max(price) as precio_max,					        -- Precio maximo por cada grupo
   round(avg(points),2) as puntaje_promedio_calidad,    -- Promedio por cada grupo
   round(avg(price/points),2) as valor_calidad_precio,  -- Cuanto estamos pagando por cada punto de calidad (mas bajo mejor)
   count(*) as total_vinos                              -- Cantidad de vinos por cada grupo (los separa en cantidades iguales recodar los terciles) (cuenta filas, osea vinos)
   from datos_segmentados
   group by tercil
   order by tercil;
   -- R: Lo interesante de esta pregunta es ver cuanto se esta pagando por punto de calidad en cada segmento. Destacan los vinos de calidad intermedia porque
   -- si bien su valor calidad precio es de 0.30 (un poco menos del doble respecto a los vinos caros) sus precios son muchisimo mas asequibles
   
   
-- Busqueda de las gemas ocultas
-- Con la creacion de la pregunta anterior  nace otra ¿Cuales son los mejores vinos en relacion calidad/precio?
-- buscaremos el 20% de mejor calidad tambien usando percentiles 
-- En si estamos buscando "gemas ocultas" vinos dentro del quintil superior 
with ranking_calidad as(							-- Nombre CTE
select
	id,
	designation,   									-- El viñedo
    country,	   									-- Pais
    price,		   									-- Precio
    points,		   									-- Puntaje
    ntile(5) over(order by points desc) as quintil  -- Separa los registros en quintiles. Esto lo hace ordenando previamente los precios en orden descendente  
    from dataset_vinos								-- Origen de la informacion
    where price is not null and price >0			-- Condiciones 
)
select 
	id,
	designation,
    country,
    price,
    points,
    round(points/price,2) as indice_valor 			-- Cuantos puntos de calidad obtenemos por cada unidad de precio (mas alto= mejor precio Y as calidad por menos dinero)
    from ranking_calidad							-- Referencia a la tabla fantasma
    where quintil=1									-- El mejor 20%
    order by indice_valor desc;						--  De mayor a menor beneficio 
-- Esto da como resultado los top 20% mejores vinos respecto a su calidad y que ademas tienen la mejor relacion calidad-precio
-- R: El mejor vino, con un indice de valor de 7.00 es el vino numero 127 de francia originario de la viña 'alsace one' a solo 13um

-- ¿Cual es el mejor vino de cada pais??

with ranking_vinos as(                             -- CTE (Common Table Expression) resultado temporal existe dentro de una consulta
select 											   -- NO es una tabla real PERO es una tabla logico/virtual (osea no es una tabla pero se utiliza como si fuera una)
	country,									   -- Puedes utilizar el resultado COMO SI FUERA una tabla 
    designation,
    points,
    price,
    rank() over(partition by country order by points desc, price asc) as posicion			   -- rank() es una window function porque calcula valores usando filas relacionadas, pero sin agruparlas
	from dataset_vinos 								                                           -- en una sola fila. la funcion 'group by' se encargara de esto por paises 
																							   -- 'partition by' divide los datos en grupos indeendientes por pais (rankinds dentro de cada pais)
	where country is not null and price is not null 	
)
select * from ranking_vinos 																   -- * significa 'llamar a todas las columnas'
where posicion =1;

-- R: Del resultado se aprecia que la gran mayoria de paises tienen al menos un vino insignia que esta sobre los 90 puntos y que los rangos
-- de precio entre paises van entre los 15 um a las 50 um



														-- Modelamiento de datos--
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Normalizamos los datos para evitar redundancias y mejorar algunas consultas 

-- Creamos la tabla de catadores
create table catadores (					
id int not null auto_increment,
taster_name varchar(50) not null,
 taster_twitter_handle varchar(250),			-- Algunos catadores no tienen twt
 primary key(id)
);

-- Insertamos datos a la tabla de catadores
insert into catadores (taster_name, taster_twitter_handle)
select distinct 
	taster_name,
	taster_twitter_handle
from dataset_vinos
where taster_name is not null;
select * from catadores;

-- Creamos la tabla de vinos
create table vinos(
id int not null auto_increment,    -- Id original del dataset, el seleccionarlo como PK garantiza que no existan duplicados (QUE FUNCIONE COMO IDENTIFICADOR UNICO)
country varchar(50),
designation varchar(255),
price 	decimal(10,2),
points int,
taster_id int not null,   
primary key(id),                                                 -- foreing keys hacia la tabla de catadores (not null= el vino debe tenre catador)
foreign key (taster_id) references catadores(id)                 -- La foreing key hace referencia a la tabla 'catadores' especificamente al id de estos
);

-- Insertamos datos a la tabla de vinos
insert into vinos (country, designation, price, points, taster_id) -- Donde se van a ingresar los valores
select 
	d.country,
    d.designation,
    d.price,
    d.points,
    c.id                          -- id en la tabla de catadores
from dataset_vinos as d
join catadores as c               -- unimos una parte de la tabla (la id de catadores no esta en la tabla principal)
on d.taster_name=c.taster_name;   -- Condicion para que el join se aplique   
select * from vinos;


-- Que catador es mas estricto?
select 												 -- Select siempre es = que columnas mostrar  
	c.taster_name as n_catador,
    avg(v.points) as promedio_puntaje,
    count(*) as cantidad_vinos                 		 -- Cuantos vinos evaluo (cuantas filas)
    from vinos as v								     --  La tabla base. from = empiezo con esta tabla
   join catadores as c on v.taster_id = c.id         -- (inner )Join = Combina filas de ambas tablas y como los voy a combinar. Mejora la tabla base vinos con tabla catadores 
												     -- usaremos info de la tabla catadores cuando se cumpla cierta condicion
    group by c.taster_name							 -- Agrupa por nombre catador desp calcula el promedio y contar la cant de vinos 
    order by promedio_puntaje asc;

-- dato freak: como todos los vinos tienen un catador (taster_id) si usamos left join el resultado sera exactamente lo mismo 
-- R Sean P. sullivan con un promedio de 86.333


-- ¿puntaje promedio de cada catador en cada pais?
SELECT 
    c.taster_name,
    v.country,
    AVG(v.points) as promedio
FROM vinos v
JOIN catadores c ON v.taster_id = c.id
GROUP BY c.taster_name, v.country;
-- R: Tecnicamente no se esta respondiendo una pregunta. esta query es solo para apreciar la diferencia de puntajes al momento de que los catdores 
-- Prueben vinos de otros paises 

-- mejora tus insight.
-- “Francia lidera en puntaje promedio, pero con menor volumen que US, lo que sugiere posible sesgo por muestra”
