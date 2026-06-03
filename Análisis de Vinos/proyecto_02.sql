-- 							-------------------------------------------------------------------------------------
-- 							-------------------------------------------------------------------------------------
-- 														 PROYECTO PORTAFOLIO MYSQL
-- 														   	ANALISIS DE VINOS 
-- 							-------------------------------------------------------------------------------------
-- 							-------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
														--  RESUMEN Y CONCLUSIONES --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Se realizo un analisis del dataset de vinos de todo el mundo siendo un cliente con la intencion de encontrar el pais con mejores vinos 
-- para analizar su relacion calidad/precio.

-- ¿Que pais tiene los vinos mejor puntuados?
	-- R: Austria destaca con el promedio de puntos mas alto. Unos 90.6 de promedio con una desviacion estandar baja de 1.74
			
		-- En el pais ganador, un precio alto implica una mejora de calidad?
			-- R: Analizando los vinos en Austria a primera vista parece que si, ya que, a mayor precio mejor es la calidad del vino (no se consideraron los vinos null)
		
        -- En el pais ganador, los puntajes y precios estan muy dispersos entre si? que quiere decir esto?
			-- R: Los precios presentan dispercion cuando hablamos de terciles.
			-- R: La dispercion de puntaje y de deprecios por segmentos es de 1.7 y 4.42 respectivamente
            
            
-- Existen vinos de buena calidad fuera del pais ganador?
	-- R: Si, existen vinos de muy buena calidad e incluso a mejor precio fuera de austria

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
														--  PARTE TECNICA --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Se busca demostrar un manejo basico de bases de datos realizando: Creacion de la base de datos, limpieza del dataset, Analisis exploratorio basico,
-- Preguntas generales (no necesariamente las mismas de la seccion 'resumen conclusiones ') y modelando talas de datos con la intencion
-- de demostrar conocimiento de uso de las 'foreign keys', joins entre otros.



-- 														-- Limpieza de datos --
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
									  -- si la consulta devuelve nada significa que esta en su totalidad es texo y podemos transformar text->int  ¡lo esta!

-- A continuacion limpiamos el resto de las columnas del dataset
-- trim() es una herramienta que nos ayuda a eliminar los espacios en las orillas del contenido de las celdas
-- Si despues de ocupar trim obtenemos una celda vacia " " cambiamos su estado a null.
-- Como estamos realizando modificaciones generales a la tabla con un where y no directamente sobre el id (que es irrepetible) desactivaremos el modo seguro

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
 

 
														-- Analisis exploratorio basico --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Revisamos el Dataset de forma general
-- Consultas rapidas que brindan informacion util
                           
-- ¿Cuantos registros/vinos tiene el dataset?
select count(*) as total_registros from dataset_vinos; 
select * from dataset_vinos;        							     -- Comprobacion visual (Considerar que para datasets con mas datos esto es peligroso)
-- R: 304 registros 

-- ¿Cuantos paises estan participando?                                 
select count(distinct country) as paises from dataset_vinos; 
select
row_number() over(order by country) as indice, country as pais		 -- Le colocamos un indice numerico
from(select distinct country from dataset_vinos) as paises;  		 -- Usamos una tabla derivada  
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
-- R: El rango de puntos va desde los 85 hasta los 92 puntos


														-- Preguntas de analisis --
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Preguntas un poco mas complejas 


-- ¿Que pais tiene los mejores vinos?
select country as pais, 
		round(avg(points),2) as puntaje_promedio, 
        round(stddev(points),2) as std_puntaje,   -- Desviacion estandar del puntaje
        round(avg(price),2) as precio,
		round(stddev(price),2) as std_precio,     -- Desviacion estandar de los precios
        count(*) as vinos_diferentes
from dataset_vinos
group by pais
order by puntaje_promedio desc;


with pais_ganador as( 			-- Primer CTE 
	select country
    from dataset_vinos
    group by country
    order by avg(points) desc
    limit 1
),
datos_segmentados as (          -- Segundo CTE
	select 
    points,
    price,
    ntile(3) over(order by price) as tercil
    from dataset_vinos
    where price is not null 
		and country =(select country from pais_ganador)
)
select
	case 
		when tercil = 1 then "1.Barato"
        when tercil = 2 then "2.Intermedio"
        when tercil = 3 then "3.Caro"
        end as segmento,
        -- Rango de precios
        min(price) as precio_min,
        max(price) as precio_max,
		round(stddev(price),2) as std_precio,     -- Desviación estandar precio (para nuestro caso particular no es muy interesante)
        -- Puntaje
        round(avg(points),2) as puntaje_promedio_calidad,
		round(stddev(points),2) as std_puntaje,					-- Desviación estandar precio (para nuestro caso particular no es muy interesante)
        round(avg(price/points),2) as valor_calidad_precio,		-- Cuanto estamos pagando por cada punto de calidad (mas bajo mejor)
        count(*) as total_vinos
from datos_segmentados 
group by tercil 
order by tercil;

select *
from dataset_vinos
where country="austria";



with pais_ganador as( 			
	select country
    from dataset_vinos
    group by country
    order by avg(points) desc
    limit 1
),
datos_segmentados as (          
	select 
    points,
    price,
    ntile(3) over(order by price) as tercil
    from dataset_vinos
    where price is not null 
		and country =(select country from pais_ganador)
),
resumen as (
	select
		tercil,
		avg(points) as avg_points,
		avg(price) as avg_price
	from datos_segmentados
	group by tercil
)
select
	round(stddev(avg_points),2) as std_entre_segmentos_puntos,
    round(stddev(avg_price),2) as std_entre_segmentos_precios
from resumen;
-- Terciles pais ganador
-- std_entre_segmentos_puntos. diferencia hay en la calidad (puntos) entre los tres segmentos
-- std_entre_segmentos_precios. dispercion de los precios promedio de esos tres grupos entre sí



-- Busqueda de las gemas ocultas
-- Con la creacion de la pregunta anterior  nace otra ¿Cuales son los mejores vinos en relacion calidad/precio?
-- buscaremos el 20% de mejor calidad tambien usando percentiles 
-- Estamos buscando "gemas ocultas" vinos dentro del quintil superior 
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
    round(points/price,2) as indice_valor 			-- Cuantos puntos de calidad obtenemos por cada unidad de precio (UM)
													-- (mas alto= mejor precio Y mas calidad por menos dinero)
    from ranking_calidad							-- Referencia a la tabla fantasma
    where quintil=1									-- El mejor 20%
    order by indice_valor desc;						--  De mayor a menor beneficio 
-- Esto da como resultado los top 20% mejores vinos respecto a su calidad y que ademas tienen la mejor relacion calidad-precio
-- R: El mejor vino, con un indice de valor de 7.00 es el vino numero 127 de francia originario de la viña 'alsace one' a solo 13um (Unidad Moneratia)


-- 127	Alsace One			 France	13.00	91	7.00
-- 280	Schiefer Reserve	Austria	24.00	92	3.83

-- Esto ultimo nos hace preguntarnos ¿realmente existe una correlacion precio calidad?
select 
    country,
    round((
        avg(price * points) - avg(price) * avg(points)
    ) / (stddev(price) * stddev(points)),2) as correlacion
from dataset_vinos
where price is not null
group by country
order by correlacion desc;

														-- Modelamiento de datos--
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Normalizamos los datos para evitar redundancias y demostrar manejo en la creacion de tablas

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

-- Configuración de acceso para Power BI
-- SHOW VARIABLES LIKE 'port';
-- SHOW VARIABLES LIKE 'bind_address';

-- Crear usuario con permisos limitados (solo lectura)
-- CREATE USER 'powerbi_user'@'localhost' IDENTIFIED BY '[PASSWORD]';
-- GRANT SELECT ON vino.* TO 'powerbi_user'@'localhost';
-- FLUSH PRIVILEGES;

-- Verificar usuario creado
-- SELECT user, host FROM mysql.user WHERE user = 'powerbi_user';