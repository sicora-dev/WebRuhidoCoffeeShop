CREATE DATABASE IF NOT EXISTS ruhido;

USE ruhido;

DROP TABLE IF EXISTS suscripcion;
DROP TABLE IF EXISTS empleado_local;
DROP TABLE IF EXISTS producto_local;
DROP TABLE IF EXISTS pago;
DROP TABLE IF EXISTS pedido_producto;
DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS local;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS cliente;


CREATE TABLE cliente (mail_cliente VARCHAR(100) primary key,
					nombre_cliente VARCHAR (45) NOT NULL,
                    apellido_cliente VARCHAR(45) NOT NULL,
                    contrasena_cliente VARCHAR(40) NOT NULL,
                    direccion_cliente VARCHAR(100),
                    ciudad_cliente VARCHAR(50) NOT NULL,
                    telefono_cliente VARCHAR(15),
                    codigo_postal_cliente CHAR(5) NOT NULL
);

CREATE TABLE producto (id_producto INT primary key auto_increment,
						nombre_producto VARCHAR(100) NOT NULL,
						precio_venta DECIMAL(6,2) NOT NULL,
                        descripcion TEXT,
                        categoria_producto ENUM("drink","bakery", "retail", "merchandising", "course", "house_equipment", "suscription") NOT NULL,
                        talla ENUM("S", "M", "L"),
                        origen_cafe VARCHAR(100),
						peso_retail ENUM("250gr","1kg"),
						tueste ENUM("espresso", "filtro"),
						molido ENUM("espresso","moka","french_press","V60","aeropress"),
                        url_imagen VARCHAR(200)
                        
);

CREATE TABLE empleado (DNI_empleado VARCHAR(12) primary key,
						nick_app VARCHAR(16),
                        contrasena_empleado VARCHAR(40) NOT NULL,
                        nombre_empleado VARCHAR(40) NOT NULL,
                        apellido_empleado VARCHAR(40) NOT NULL,
                        apellido2_empleado VARCHAR(40),
                        telefono_empleado VARCHAR(15),
                        email_empleado VARCHAR(255) NOT NULL,
                        salario_empleado DECIMAL(7,2)
);

CREATE TABLE local (cod_local VARCHAR(20) primary key, -- H38, PDV245
					direccion_local VARCHAR(200) NOT NULL,
                    ciudad_local VARCHAR(100) NOT NULL,
                    codigo_postal_local CHAR(5) NOT NULL,
                    tipo_local ENUM("take_away","cafeteria","warehouse", "oficina") NOT NULL
);

CREATE TABLE pedido(id_pedido INT primary key auto_increment,
					fecha_pedido DATETIME NOT NULL,
                    fk_mail_cliente VARCHAR(255),
                    fk_cod_local VARCHAR(20) NOT NULL, 
                    precio_total_pedido DECIMAL(7,2) NOT NULL,
			FOREIGN KEY (fk_mail_cliente) REFERENCES cliente(mail_cliente),
            FOREIGN KEY (fk_cod_local) REFERENCES local(cod_local)
);

CREATE TABLE pedido_producto(id_producto_pedido INT primary key auto_increment,
								fk_producto INT NOT NULL,
                                fk_pedido INT NOT NULL,
                                cantidad INT NOT NULL,
                                precio_unidad DECIMAL(6,2),
				FOREIGN KEY (fk_producto) REFERENCES producto(id_producto),
				FOREIGN KEY (fk_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE pago(id_pago INT primary key auto_increment,
					forma_pago ENUM("tarjeta", "efectivo", "paypal") NOT NULL,
                    fecha_pago DATETIME NOT NULL,
                    fk_pedido INT NOT NULL,
                    total DECIMAL (6,2) NOT NULL,
			FOREIGN KEY (fk_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE producto_local (id_producto_local INT primary key auto_increment,
							fk_producto INT NOT NULL,
							fk_cod_local VARCHAR(20) NOT NULL,
                            cantidad_stock INT,
				FOREIGN KEY (fk_producto) REFERENCES producto(id_producto),
				FOREIGN KEY (fk_cod_local) REFERENCES local(cod_local)
);


CREATE TABLE empleado_local (id_empleado_local INT primary key auto_increment,
							fk_DNI_empleado VARCHAR(12) NOT NULL,
                            fk_cod_local VARCHAR(20) NOT NULL,
                            puesto_empleado VARCHAR(100),
				FOREIGN KEY (fk_DNI_empleado) REFERENCES empleado(DNI_empleado),
				FOREIGN KEY (fk_cod_local) REFERENCES local(cod_local)
);

CREATE TABLE suscripcion ( id_suscripcion INT primary key auto_increment,
							tipo_suscripcion ENUM ("basic","pro") NOT NULL,
                            fecha_alta DATETIME NOT NULL,
                            fecha_vencimiento DATETIME NOT NULL,
                            precio_suscripcion DECIMAL (4,2) NOT NULL,
                            fk_mail_cliente VARCHAR (255) NOT NULL,
				FOREIGN KEY (fk_mail_cliente) REFERENCES cliente(mail_cliente)
);


-- La vista nos proporciona el mail del cliente, con el código del local, 
-- con los productos totales que han comprado y el valor total de estos.
-- Dicho resultado está ordenado alfabéticamente por el mail del cliente.
-- El local es de la ciudad de Madrid y los clientes habrán de haber comprado 3 o más productos. 
-- Unimos la tabla cliente con pedido, luego se obtiene la información sobre los locales, 
-- después obtenemos la información sobre los productos de cada pedido 
-- y luego obtenemos la información de los pagos de cada pedido. 
-- Además obtenemos los resultados de los clientes que hayan comprado 3 o más productos

DROP PROCEDURE IF EXISTS RegistrarEmpleadoJava;
DELIMITER //
CREATE PROCEDURE RegistrarEmpleadoJava(IN _DNI VARCHAR (12),
						   IN _nick_app VARCHAR(16),
						   IN _nombre VARCHAR (40),
                           IN _apellido VARCHAR (40),
                           IN _apellido2 VARCHAR (40),
                           IN _telefono_empleado VARCHAR (15),
                           IN _mail VARCHAR (255),
                           IN _salario DECIMAL (7,2),
                           IN _password VARCHAR (40),
                           OUT _resultado INT)
BEGIN
DECLARE existe VARCHAR (12);
	SET existe = NULL;
	SELECT DNI_empleado FROM empleado WHERE DNI_empleado LIKE _DNI
	INTO existe;

-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un apellido vacío o nulo
	ELSEIF(_apellido IS NULL OR _apellido LIKE "")THEN
		SET _resultado = -2;
-- CASO -3 El usuario ya existe (DNI repetido)
	ELSEIF(existe IS NOT NULL)THEN
		SET _resultado = -3;
-- CASO -4 Nos intentan entregar un segundo apellido vacío
	ELSEIF(_apellido2 LIKE "")THEN
		SET _resultado = -4;
-- CASO -5 El mail es vacío o nulo
	ELSEIF(_mail IS NULL OR _mail LIKE "") THEN
		SET _resultado = -5; 
-- CASO -6 El mail no tiene forma de mail
	/*ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -6;        */
-- CASO -7 Contraseña vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "") THEN
		SET _resultado = -7;   
-- CASO -8 DNI vacío o nulo
	ELSEIF(_DNI IS NULL OR _DNI LIKE "") THEN
		SET _resultado = -8; 
-- CASO -9 Salario negativo
	ELSEIF(_salario < 0 && _salario IS NOT NULL) THEN
		SET _resultado = -9; 
-- CASO -10 Nos intentan entregar un nick vacío
	ELSEIF(_nick_app LIKE "") THEN
		SET _resultado = -10;
	ELSE 
-- CASO 0 - TODO OK
		INSERT INTO empleado(DNI_empleado,nick_app,contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado)
		VALUES (_DNI, _nick_app, _password, _nombre, _apellido, _apellido2, _telefono_empleado, _mail, _salario);
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;

DROP VIEW IF EXISTS vista_pedidos;
CREATE VIEW vista_pedidos AS
SELECT c.mail_cliente, l.cod_local, l.ciudad_local, COUNT(p_prod.fk_producto) AS total_productos, SUM(pag.total) AS total_pago
FROM cliente c JOIN pedido p ON (c.mail_cliente = p.fk_mail_cliente) JOIN local l ON (p.fk_cod_local = l.cod_local) LEFT JOIN pedido_producto p_prod ON (p.id_pedido = p_prod.fk_pedido) JOIN pago pag ON (p.id_pedido = pag.fk_pedido)  
WHERE l.ciudad_local LIKE "Madrid"
GROUP BY c.mail_cliente, l.cod_local
HAVING total_productos >= 3
ORDER BY c.mail_cliente;



USE ruhido;

DROP PROCEDURE IF EXISTS ModificarCliente;
DELIMITER //

CREATE PROCEDURE ModificarCliente(IN _mail VARCHAR (255),
								  IN _nombre VARCHAR (45),
								  IN _apellido VARCHAR (45),
								  IN _password VARCHAR (40),
								  IN _direccion_cliente VARCHAR (100),
								  IN _ciudad_cliente VARCHAR (50),
								  IN _telefono VARCHAR (15),
								  IN _codigo_postal_cliente CHAR (5),
								  OUT _resultado INT)
BEGIN
DECLARE existe, longitud_codigo_postal_cliente INT;
	SET existe = NULL;
    SET longitud_codigo_postal_cliente = NULL;
	SELECT COUNT(*) FROM cliente WHERE mail_cliente LIKE _mail
	INTO existe;
    SELECT LENGTH(_codigo_postal_cliente) WHERE _codigo_postal_cliente IS NOT NULL
    INTO longitud_codigo_postal_cliente;


-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un apellido vacío o nulo
	ELSEIF(_apellido IS NULL OR _apellido LIKE "")THEN
		SET _resultado = -2;
-- CASO -3 El usuario no existe
	ELSEIF(existe IS NULL OR existe = 0)THEN
		SET _resultado = -3;
-- CASO -4 El mail es vacío o nulo
	ELSEIF(_mail IS NULL OR _mail LIKE "") THEN
		SET _resultado = -4;
-- CASO -5 El mail no tiene forma de mail
	ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -5;        
-- CASO -6 El codigo postal no tiene el tamaño de código postal
	ELSEIF(longitud_codigo_postal_cliente != 5) THEN
		SET _resultado = -6;
-- CASO -7 Contraseña vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "") THEN
		SET _resultado = -7;    
-- CASO -8 Telefono vacío
	ELSEIF(_telefono LIKE "") THEN
		SET _resultado = -8; 
-- CASO -9 Dirección del cliente vacío
	ELSEIF(_direccion_cliente LIKE "") THEN
		SET _resultado = -9; 
-- CASO -10 Nos intentan entregar una ciudad vacía o nula
	ELSEIF(_ciudad_cliente IS NULL OR _ciudad_cliente LIKE "")THEN
		SET _resultado = -10;
	ELSE 
-- CASO 0 - TODO OK
		UPDATE cliente
		SET nombre_cliente = _nombre, apellido_cliente = _apellido, contrasena_cliente = _password, direccion_cliente = _direccion_cliente, ciudad_cliente = _ciudad_cliente, telefono_cliente = _telefono, codigo_postal_cliente = _codigo_postal_cliente
        WHERE mail_cliente = _mail
        LIMIT 1;
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS RegistrarCliente;
DELIMITER //
CREATE PROCEDURE RegistrarCliente(IN _mail VARCHAR (255),
								  IN _nombre VARCHAR (45),
								  IN _apellido VARCHAR (45),
								  IN _password VARCHAR (40),
								  IN _direccion_cliente VARCHAR (100),
								  IN _ciudad_cliente VARCHAR (50),
								  IN _telefono VARCHAR (15),
								  IN _codigo_postal_cliente CHAR (5),
								  OUT _resultado INT)
BEGIN
DECLARE existe, longitud_codigo_postal_cliente INT;
	SET existe = NULL;
    SET longitud_codigo_postal_cliente = NULL;
	SELECT COUNT(mail_cliente) FROM cliente WHERE mail_cliente LIKE _mail
	INTO existe;
    SELECT LENGTH(_codigo_postal_cliente) WHERE _codigo_postal_cliente IS NOT NULL
    INTO longitud_codigo_postal_cliente;


-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un apellido vacío o nulo
	ELSEIF(_apellido IS NULL OR _apellido LIKE "")THEN
		SET _resultado = -2;
-- CASO -3 El usuario ya existe
	ELSEIF(existe IS NOT NULL AND existe > 0)THEN
		SET _resultado = -3;
-- CASO -4 El mail es vacío o nulo
	ELSEIF(_mail IS NULL OR _mail LIKE "") THEN
		SET _resultado = -4;
-- CASO -5 El mail no tiene forma de mail
	ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -5;        
-- CASO -6 El codigo postal no tiene el tamaño de código postal
	ELSEIF(longitud_codigo_postal_cliente != 5) THEN
		SET _resultado = -6;
-- CASO -7 Contraseña vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "") THEN
		SET _resultado = -7;    
-- CASO -8 Telefono vacío
	ELSEIF(_telefono LIKE "") THEN
		SET _resultado = -8; 
-- CASO -9 Dirección del cliente vacío
	ELSEIF(_direccion_cliente LIKE "") THEN
		SET _resultado = -9; 
-- CASO -10 Nos intentan entregar una ciudad vacía o nula
	ELSEIF(_ciudad_cliente IS NULL OR _ciudad_cliente LIKE "")THEN
		SET _resultado = -10;
	ELSE 
-- CASO 0 - TODO OK
		INSERT INTO cliente(mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente)
		VALUES (_mail, _nombre, _apellido, _password, _direccion_cliente, _ciudad_cliente, _telefono, _codigo_postal_cliente);
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS BorrarCliente;
DELIMITER //
CREATE PROCEDURE BorrarCliente( IN _mail VARCHAR (255),
								IN _password VARCHAR (40), 
								OUT _resultado INT)
BEGIN
	DECLARE coincide VARCHAR (255);
	SET coincide = NULL;
	SELECT mail_cliente FROM cliente WHERE mail_cliente LIKE _mail AND _password LIKE contrasena_cliente
	INTO coincide;
    
-- CASO -1 Nos intentan entregar un mail vacío o nulo
	IF(_mail IS NULL OR _mail LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 El mail no tiene forma de mail
	ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -2;  
-- CASO -3 La contraseña está vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "")THEN
		SET _resultado = -3;
-- CASO -4 La contraseña no coincide con el mail
	ELSEIF(coincide IS NULL) THEN
		SET _resultado = -4;
	ELSE 
-- CASO 0 - TODO OK
		DELETE 
		FROM cliente
		WHERE mail_cliente LIKE _mail
		LIMIT 1;
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS RegistrarEmpleado;
DELIMITER //
CREATE PROCEDURE RegistrarEmpleado(IN _DNI VARCHAR (12),
						   IN _nick_app VARCHAR(16),
						   IN _nombre VARCHAR (40),
                           IN _apellido VARCHAR (40),
                           IN _apellido2 VARCHAR (40),
                           IN _telefono_empleado VARCHAR (15),
                           IN _mail VARCHAR (255),
                           IN _salario DECIMAL (7,2),
                           IN _password VARCHAR (40),
                           OUT _resultado INT)
BEGIN
DECLARE existe VARCHAR (12);
	SET existe = NULL;
	SELECT DNI_empleado FROM empleado WHERE DNI_empleado LIKE _DNI
	INTO existe;

-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un apellido vacío o nulo
	ELSEIF(_apellido IS NULL OR _apellido LIKE "")THEN
		SET _resultado = -2;
-- CASO -3 El usuario ya existe (DNI repetido)
	ELSEIF(existe IS NOT NULL)THEN
		SET _resultado = -3;
-- CASO -4 Nos intentan entregar un segundo apellido vacío
	ELSEIF(_apellido2 LIKE "")THEN
		SET _resultado = -4;
-- CASO -5 El mail es vacío o nulo
	ELSEIF(_mail IS NULL OR _mail LIKE "") THEN
		SET _resultado = -5; 
-- CASO -6 El mail no tiene forma de mail
	ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -6;        
-- CASO -7 Contraseña vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "") THEN
		SET _resultado = -7;   
-- CASO -8 DNI vacío o nulo
	ELSEIF(_DNI IS NULL OR _DNI LIKE "") THEN
		SET _resultado = -8; 
-- CASO -9 Salario negativo
	ELSEIF(_salario < 0 && _salario IS NOT NULL) THEN
		SET _resultado = -9; 
-- CASO -10 Nos intentan entregar un nick vacío
	ELSEIF(_nick_app LIKE "") THEN
		SET _resultado = -10;
	ELSE 
-- CASO 0 - TODO OK
		INSERT INTO empleado(DNI_empleado,nick_app,contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado)
		VALUES (_DNI, _nick_app, _password, _nombre, _apellido, _apellido2, _telefono_empleado, _mail, _salario);
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS ModificarEmpleado;
DELIMITER //
CREATE PROCEDURE ModificarEmpleado(IN _DNI VARCHAR (12),
						   IN _nick_app VARCHAR(16),
                           IN _password VARCHAR (40),
						   IN _nombre VARCHAR (40),
                           IN _apellido VARCHAR (40),
                           IN _apellido2 VARCHAR (40),
                           IN _telefono_empleado VARCHAR (15),
                           IN _mail VARCHAR (255),
                           IN _salario DECIMAL (7,2),
                           OUT _resultado INT)
BEGIN
DECLARE coincide INT;
	SET coincide = NULL;
	SELECT COUNT(*) FROM empleado WHERE DNI_empleado LIKE _DNI
	INTO coincide;
-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un apellido vacío o nulo
	ELSEIF(_apellido IS NULL OR _apellido LIKE "")THEN
		SET _resultado = -2;
-- CASO -3 El usuario no existe (DNI inexistente)
	ELSEIF(coincide IS NULL OR coincide = 0)THEN
		SET _resultado = -3;
-- CASO -4 Nos intentan entregar un segundo apellido vacío
	ELSEIF(_apellido2 LIKE "")THEN
		SET _resultado = -4;
-- CASO -5 El mail es vacío o nulo
	ELSEIF(_mail IS NULL OR _mail LIKE "") THEN
		SET _resultado = -5; 
-- CASO -6 El mail no tiene forma de mail
	ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -6;        
-- CASO -7 Contraseña vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "") THEN
		SET _resultado = -7;   
-- CASO -8 DNI vacío o nulo
	ELSEIF(_DNI IS NULL OR _DNI LIKE "") THEN
		SET _resultado = -8; 
-- CASO -9 Salario negativo
	ELSEIF(_salario < 0 && _salario IS NOT NULL) THEN
		SET _resultado = -9; 
-- CASO -10 Nos intentan entregar un nick vacío
	ELSEIF(_nick_app LIKE "") THEN
		SET _resultado = -10;
	ELSE 
-- CASO 0 - TODO OK
		UPDATE empleado
		SET nick_app = _nick_app, contrasena_empleado = _password, nombre_empleado = _nombre, apellido_empleado = _apellido, apellido2_empleado = _apellido2,telefono_empleado = _telefono_empleado, email_empleado = _mail, salario_empleado =_salario 
        WHERE DNI_empleado = _DNI
        LIMIT 1;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS BorrarEmpleado;
DELIMITER //
CREATE PROCEDURE BorrarEmpleado( IN _DNI VARCHAR (12),
								IN _password VARCHAR (40), 
								OUT _resultado INT)
BEGIN
	DECLARE coincide VARCHAR (12);
	SET coincide = NULL;
	SELECT DNI_empleado FROM empleado WHERE DNI_empleado LIKE _DNI AND _password LIKE contrasena_empleado
	INTO coincide;
    
-- CASO -1 Nos intentan entregar un DNI vacío o nulo
	IF(_DNI IS NULL OR _DNI LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 La contraseña está vacía o nula
	ELSEIF(_password IS NULL OR _password LIKE "")THEN
		SET _resultado = -2;
-- CASO -3 La contraseña no coincide con el DNI
	ELSEIF(coincide IS NULL) THEN
		SET _resultado = -3;
	ELSE 
-- CASO 0 - TODO OK
		DELETE 
		FROM empleado
		WHERE DNI_empleado LIKE _DNI
		LIMIT 1;
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS LoginCliente;
DELIMITER //
CREATE PROCEDURE LoginCliente( IN _mail VARCHAR (255),
						IN _password VARCHAR (40), 
						OUT _resultado INT)
BEGIN
	DECLARE contrasennaIncorrecta VARCHAR (40);
    DECLARE existe INT;
	SET contrasennaIncorrecta = NULL;
    SET existe = NULL;
	SELECT contrasena_cliente FROM cliente WHERE mail_cliente LIKE _mail AND _password LIKE contrasena_cliente
	INTO contrasennaIncorrecta;
    SELECT COUNT(mail_cliente) FROM cliente WHERE mail_cliente LIKE _mail
	INTO existe;

	-- CASO -1 - mail Nulo o blanco
    IF(_mail IS NULL OR _mail LIKE "")THEN
		SET _resultado = -1;
	-- CASO -2 - mail inexistente
    ELSEIF(existe IS NULL OR existe < 1)THEN
		SET _resultado = -2;
-- CASO -3 El mail no tiene forma de mail
	ELSEIF(_mail NOT LIKE "%@%.%" OR _mail LIKE "%@" OR _mail LIKE "@%" OR _mail LIKE "%." OR _mail LIKE "%@.%") THEN
		SET _resultado = -3;  
-- CASO -4 - Contraseña vacía o nula
    ELSEIF(_password IS NULL OR _password LIKE "")THEN
		SET _resultado = -4;
-- CASO -5 - Contraseña incorrecta
    ELSEIF(contrasennaIncorrecta IS NULL)THEN
		SET _resultado = -5;
	-- CASO 0 - TODO OK
    ELSE
		SET  _resultado = 0;
    END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS LoginEmpleado;
DELIMITER //
CREATE PROCEDURE LoginEmpleado( IN _DNI VARCHAR (12),
						IN _password VARCHAR (40), 
						OUT _resultado INT)
BEGIN
	DECLARE contrasennaIncorrecta VARCHAR (40);
    DECLARE coincide INT;
	SET contrasennaIncorrecta = NULL;
    SET coincide = NULL;
	SELECT contrasena_empleado FROM empleado WHERE DNI_empleado LIKE _DNI AND _password LIKE contrasena_empleado
	INTO contrasennaIncorrecta;
    SELECT COUNT(DNI_empleado) FROM empleado WHERE DNI_empleado LIKE _DNI
	INTO coincide;

	-- CASO -1 - DNI Nulo o blanco
    IF(_DNI IS NULL OR _DNI LIKE "")THEN
		SET _resultado = -1;
	-- CASO -2 - DNI inexistente
    ELSEIF(coincide IS NULL OR coincide < 1)THEN
		SET _resultado = -2;
-- CASO -3 - Contraseña vacía o nula
    ELSEIF(_password IS NULL OR _password LIKE "")THEN
		SET _resultado = -3;
-- CASO -4 - Contraseña incorrecta
    ELSEIF(contrasennaIncorrecta IS NULL)THEN
		SET _resultado = -4;
	-- CASO 0 - TODO OK
    ELSE
		SET  _resultado = 0;
    END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS DarAltaProducto;
DELIMITER //
CREATE PROCEDURE DarAltaProducto(IN _nombre VARCHAR (45),
                           IN _precio_venta DECIMAL (6,2),
                           IN _descripcion TEXT,
                           IN _categoria_producto ENUM("drink","bakery", "retail", "merchandising", "course", "house_equipment", "suscription"),
                           IN _talla ENUM ("S", "M", "L"),
                           IN _origen VARCHAR (100),
                           IN _peso ENUM ("250gr", "1kg"),
                           IN _tueste ENUM("espresso", "filtro"),
                           IN _molido ENUM("espresso","moka","french_press","V60","aeropress"),
                           OUT _resultado INT)
BEGIN
DECLARE coincide VARCHAR (45);
	SET coincide = NULL;
	SELECT nombre_producto FROM producto WHERE nombre_producto LIKE _nombre
	INTO coincide;

-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un precio de venta nulo
	ELSEIF(_precio_venta IS NULL)THEN
		SET _resultado = -2;
-- CASO -3 Nos intentan entregar un precio de venta negativo
	ELSEIF(_precio_venta < 0)THEN
		SET _resultado = -3;
-- CASO -4 Introducen un nombre de producto ya existente
	ELSEIF(coincide IS NOT NULL)THEN
		SET _resultado = -4;
-- CASO -5 Nos intentan entregar un origen de cafe vacío
	ELSEIF(_origen LIKE "") THEN
		SET _resultado = -5;
-- CASO -6 Nos intentan entregar una descripcion vacía
	ELSEIF(_descripcion LIKE "") THEN
		SET _resultado = -6;
-- CASO -7 Nos intentan entregar un tueste inexistente o nulo
	ELSEIF(_tueste IS NULL OR (_tueste NOT LIKE "espresso" AND _tueste NOT LIKE "filtro")) THEN
		SET _resultado = -7;
-- CASO -8 Nos intentan entregar un molido inexistente o nulo
	ELSEIF(_molido IS NULL OR (_molido NOT LIKE "espresso" AND _molido NOT LIKE "moka" AND _molido NOT LIKE "french_press" AND _molido NOT LIKE "V60" AND _molido NOT LIKE "aeropress")) THEN
		SET _resultado = -8;
-- CASO -9 Nos intentan entregar un peso inexistente o nulo
	ELSEIF(_peso IS NULL OR (_peso NOT LIKE "250gr" AND _peso NOT LIKE "1kg")) THEN
		SET _resultado = -9;
-- CASO -10 Nos intentan entregar una talla inexistente o nula
	ELSEIF(_talla IS NULL OR (_talla NOT LIKE "S" AND _talla NOT LIKE "M" AND _talla NOT LIKE "L")) THEN
		SET _resultado = -10;
-- CASO -11 Nos intentan entregar una categoria de producto inexistente o nula
	ELSEIF(_categoria_producto IS NULL OR (_categoria_producto NOT LIKE "drink" AND _categoria_producto NOT LIKE "bakery" AND _categoria_producto NOT LIKE "retail" AND _categoria_producto NOT LIKE "merchandising" AND _categoria_producto NOT LIKE "course" AND _categoria_producto NOT LIKE "house_equipment" AND _categoria_producto NOT LIKE "suscription")) THEN
		SET _resultado = -11;
	ELSE 
-- CASO 0 - TODO OK
		INSERT INTO producto(nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido)
		VALUES (_nombre, _precio_venta, _descripcion, _categoria_producto, _talla, _origen, _peso, _tueste, _molido);
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS EliminarProducto;
DELIMITER //
CREATE PROCEDURE EliminarProducto(IN _nombre VARCHAR (45),
								  OUT _resultado INT)
BEGIN
-- CASO -1 Nos intentan entregar un nombre vacío o nulo
	IF(_nombre IS NULL OR _nombre LIKE "") THEN
		SET _resultado = -1;
	ELSE 
-- CASO 0 - TODO OK
		DELETE 
		FROM producto
		WHERE nombre_producto LIKE _nombre
		LIMIT 1;
		SET _resultado = 0;
	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS ModificarProducto;
DELIMITER //
CREATE PROCEDURE ModificarProducto(IN _id_producto INT,
                           IN _precio_venta DECIMAL (6,2),
                           IN _descripcion TEXT,
                           OUT _resultado INT)
BEGIN
-- CASO -1 Nos intentan entregar un id vacío o nulo
	IF(_id_producto IS NULL) THEN
		SET _resultado = -1;
-- CASO -2 Nos intentan entregar un precio de venta nulo
	ELSEIF(_precio_venta IS NULL)THEN
		SET _resultado = -2;
-- CASO -3 Nos intentan entregar un precio de venta negativo
	ELSEIF(_precio_venta < 0)THEN
		SET _resultado = -3;
-- CASO -4 Nos intentan entregar una descripcion vacía
	ELSEIF(_descripcion LIKE "") THEN
		SET _resultado = -4;
	ELSE 
-- CASO 0 - TODO OK
		UPDATE producto
		SET precio_venta = _precio_venta, descripcion = _descripcion
        WHERE id_producto = _id_producto
        LIMIT 1;
		SET _resultado = 0;

	END IF;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS PrecioVenta;
DELIMITER //
CREATE PROCEDURE PrecioVenta(IN _id INT)
BEGIN
	SELECT precio_venta
	FROM producto
	WHERE id_producto = _id;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS PagosDiaAnterior;
DELIMITER //
CREATE PROCEDURE PagosDiaAnterior()
BEGIN
	SELECT forma_pago, total
	FROM pago
	WHERE DATEDIFF (NOW(), fecha_pago) = 1;
END//
DELIMITER ;

   
DROP PROCEDURE IF EXISTS PagosUltimoMes;
DELIMITER //
CREATE PROCEDURE PagosUltimoMes()
BEGIN
	SELECT forma_pago, total
	FROM pago
	WHERE DATEDIFF (NOW(), fecha_pago) <= 30;
END//
DELIMITER ;



USE ruhido;


insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('leila@news.com', 'Leila', 'Garcia', 'bM7,xp#gdHP(1s$', '58765 Shelley Crossing', 'Đồng Mỏ', '711-165-6368', '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('pablo@google.cn', 'Pablo', 'Martin', 'iT3~9Y&6$`bJ', '698 Shasta Trail', 'Reshetikha', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('manuel@wired.com', 'Manuel', 'Ruan', 'lH2\bI/!Mu', null, 'Zabrze', null, '41840');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('nuria@usgs.gov', 'Nuria', 'Martinez', 'mN3`eP8#', null, 'Mayskiy', null, '16673');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('isabel@uol.com.br', 'Isabel', 'Lopez', 'gW3}QkP/A''', null, 'Kadengan', null, '66093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('nieves@paginegialle.it', 'Nieves', 'Guerra', 'uG0}I&YS+@shH64b', '633 Helena Place', 'Kuma', null, '66093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('mariana@yellowpages.com', 'Mariana', 'Parra', 'hW0%D=<s.sj%@)h~', '72 Lien Park', 'Trzin', '351-749-5678', '1236');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('maria@opensource.org', 'Maria', 'Fernandez', 'vI0}S@%@', null, 'Temirtau', null, '66093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('gaia@mit.edu', 'Gaia', 'Gutierrez', 'sP8$rFfUmdPj', null, 'Melaka', null, '75610');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('nicole@forbes.com', 'Nicole', 'Hernandez', 'xW2}#sVS>f`"R4E?', null, 'Fort-de-France', null, '75610');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('guille@google.com.hk', 'Guille', 'Escribano', 'iT3''jDEK$DGQ{', '494 American Ash Lane', 'Neringa', null, '93017');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('cristian@ted.com', 'Cristian', 'Asensio', 'oP5?1RaPu', '5 Moulton Circle', 'Mílos', null,'75610');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('marcos@weather.com', 'Marcos', 'Carbajo', 'sY4!wI2C', null, 'Puerto Guzmán', null, '75610');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('juan@nyu.edu', 'Juan', 'Minguez', 'sU5#hsI.O', null, 'Mossel Bay', null, '6511');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('isabel@simplemachines.org', 'Isabel', 'Ferres', 'iR6+S(Cu3&', null, 'Parung', '880-146-7764','75610');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('maria@tripadvisor.com', 'Maria', 'Turford', 'yU4%YFEbj~ZcZ_', '885 Fuller Road', 'Changpu', '750-125-3369', '60609');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('sonia@thetimes.co.uk', 'Sonia', 'Brugmann', 'zG4*1@N6/gk', null, 'Bijie', null, '60609');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('raquel@zdnet.com', 'Raquel', 'Hawkings', 'hP7~KT{{', null, 'Duut', null, '60609');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('vero@walmart.com', 'Veronica', 'Bentley', 'eV8$aao+s*mjA.}8', null, 'Puerto Iguazú', '952-504-6664', '3370');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('luisa@unicef.org', 'Luisa', 'Siddall', 'vJ1/f@?7a4}7U', '69 Longview Hill', 'Wuyo', null, '3370');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('manuela@techcrunch.com', 'Manuela', 'Ternott', 'eU5%hs73CAMU', '1182 Kinsman Terrace', 'Oyabe', null, '9320');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('fran@cisco.com', 'Francisco', 'Shoreson', 'zU8%27xV{uB}`>WS', null, 'Kaédi', null, '3370');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('lois@ycombinator.com', 'Lois', 'Jorcke', 'aT0<Oi.hB', null, 'Nguluhan', null, '3370');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('megane@seesaa.net', 'Megane', 'Spensly', 'vH7.CWN"=uf@oE4', null, 'Vilar do Pinheiro', '890-905-7050', '4485');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('vmorchp@netscape.com', 'Yè', 'Morch', 'wB7%OUwD', null, 'Mariano Moreno', '280-857-4630', '8357');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('mmattimoeq@yahoo.co.jp', 'Måns', 'Mattimoe', 'lE3!Oix>''(Yd', null, 'Chang’an', null, '60693');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('nrossettir@home.pl', 'Laurène', 'Rossetti', 'zT0{WLOZ/)', null, 'Candijay', null, '6312');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('mocrevys@skype.com', 'Clémence', 'O''Crevy', 'pB3+rkdtL', null, 'Fenkeng', null, '60693');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('jromagnosit@time.com', 'Néhémie', 'Romagnosi', 'nQ8''F5t8z', null, 'Rybarzowice', null, '43608');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('pbloisu@bbb.org', 'Maïly', 'Blois', 'eX7,pYj2E~rrbm<(', null, 'Dulolong', null, '60693');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('tduffanv@mozilla.com', 'Agnès', 'Duffan', 'zU7&4o@/MKq?12z', null, 'Baoxing', null, '60693');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('bipsgravew@princeton.edu', 'Åke', 'Ipsgrave', 'wS9#5k$0fu8n$', null, 'La Motte-Servolex', null, '60693');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('kkorpolakx@cam.ac.uk', 'Séréna', 'Korpolak', 'xB9"nFX1DfR8x', null, 'Dongjin', '177-227-0201', '60693');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('flemaryy@aol.com', 'Agnès', 'Lemary', 'gP1''VO@0E{0J', null, 'Dzhiginka', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('lclabburnz@sfgate.com', 'Chloé', 'Clabburn', 'iT5@.C<)', '48 Valley Edge Point', 'Portarlington', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('apiola10@addtoany.com', 'Fèi', 'Piola', 'gI0$O1SX8/@', null, 'Izumiōtsu', null, '59797');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('denrdigo11@hatena.ne.jp', 'Jú', 'Enrdigo', 'oK2?BIO=$', null, 'Hesperange', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('bisworth12@spiegel.de', 'Rachèle', 'Isworth', 'wR6(Jm7)iD$}$', null, 'Niushou', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('khammor13@ted.com', 'Loïs', 'Hammor', 'yI1?1?eZL/Q,S', '58 Aberg Lane', 'Xumu', '896-264-6105', '6093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('tyorath14@marketwatch.com', 'Bécassine', 'Yorath', 'vM9''?zf4j', null, 'Capioví', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('telgram15@bluehost.com', 'Léone', 'Elgram', 'oF3|_l)I.*d/Y>', null, 'Slobozia', '481-714-6857', '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('rkhomich16@arstechnica.com', 'Séverine', 'Khomich', 'fT5~Yw+j"''', '44 Barby Place', 'Boro Utara', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('otelford17@bizjournals.com', 'Marie-ève', 'Telford', 'mN1~G,r#A''eFy0X', '191 Aberg Hill', 'Grygov', '778-359-7083', '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('mcapener18@wisc.edu', 'Inès', 'Capener', 'aJ9%Ai8Lthms!}V1', null, 'Matungao', null, '9203');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('kmudge19@liveinternet.ru', 'Marie-noël', 'Mudge', 'cT2=ZWVB', null, 'Kotatengah', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('eputtan1a@ucoz.com', 'Naéva', 'Puttan', 'uG3=vVRTkX\kUd', null, 'København', null, '1577');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('apol1b@businesswire.com', 'Mélodie', 'Pol', 'tU8~vJ*&HND\k', null, 'Jiangshan', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('swoodcroft1c@liveinternet.ru', 'Séverine', 'Woodcroft', 'dU8,|Kl}S.(g.YRp', null, 'Manuel Antonio Mesones Muro', null, '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('acoughtrey1d@accuweather.com', 'Lóng', 'Coughtrey', 'nR4\Sh,`P', '258 Springview Pass', 'Velyka Oleksandrivka', '338-207-3479', '35680');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('pphilippsohn1e@ebay.com', 'Léonore', 'Philippsohn', 'fI4!b*T`9%4m', null, 'Saltsjö-Boo', null, '13230');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('lconnaughton1f@indiegogo.com', 'Maëline', 'Connaughton', 'vV6*~>+z94O*', null, 'Dizangué', null, '13230');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('lpollen1g@sphinn.com', 'Kù', 'Pollen', 'bN5&9x%u?<+9o', '206 Dunning Street', 'Cruzeiro', null, '13230');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('aminigo1h@smh.com.au', 'Solène', 'Minigo', 'uO5)oCOGq7d5', null, 'Ban Lam Luk Ka', null, '13230');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('lportman1i@state.gov', 'Josée', 'Portman', 'qP7=OnTjI>P', null, 'Gambut', null, '13230');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('ohandrok1j@canalblog.com', 'Médiamass', 'Handrok', 'aJ9#2ofHxU#Lx6sS', null, 'Rerawere', '164-307-0129', '60093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('fpfeffel1k@mozilla.org', 'André', 'Pfeffel', 'kR3%Piu~qc', '669 Service Lane', 'Outeirô', null, '60093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('pdyett1l@craigslist.org', 'Néhémie', 'Dyett', 'pO7{w)Y!*m0Q_s4c', null, 'Derbent', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('twardesworth1m@pinterest.com', 'Laurélie', 'Wardesworth', 'gC9`aWVzsqb#LR7', null, 'Sruni', '473-300-0822', '60093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('gbowller1n@cmu.edu', 'Maïlys', 'Bowller', 'lV4?xpG)<gbG"', null, 'Mendefera', null, '60093');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('cormerod1o@dell.com', 'Eloïse', 'Ormerod', 'vB3(EIS{#9Y%P8MC', null, 'Stockholm', null, '11176');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('flanfere1p@discuz.net', 'Maéna', 'Lanfere', 'bU8&<)wf\mlCQ', null, 'Santa Cecilia', null, '11176');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('dhartley1q@joomla.org', 'Clémence', 'Hartley', 'jP3*tuESv', null, 'Fenhe', null, '11176');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('kscolland1r@lycos.com', 'Mélanie', 'Scolland', 'rE9!_R#oBX', null, 'Sumbergedong', null, '11176');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('cgrinstead1s@t-online.de', 'Valérie', 'Grinstead', 'dL2(6!T{x"Fb#@_', null, 'Majiang', '612-940-1423', '11176');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('tportugal1t@123-reg.co.uk', 'Loïca', 'Portugal', 'nJ5=kkd!Eg#Bm', null, 'Sueyoshichō-ninokata', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('jlescop1u@rediff.com', 'Stévina', 'Lescop', 'gU7%")kX_7', '62 Loeprich Street', 'Kriel', null, '2276');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('croubeix1v@msu.edu', 'Marie-josée', 'Roubeix', 'tL4>.qnjSm0~}3N', '57 Fisk Way', 'Kislyakovskaya', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('tbeldham1w@gov.uk', 'Göran', 'Beldham', 'gL7!|)Vs2', null, 'Ayapa', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('tlermit1x@disqus.com', 'Pò', 'Lermit', 'iF4!cuksi?Kv', '41135 Pepper Wood Way', 'Banjarsari', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('zjimes1y@blogtalkradio.com', 'Marie-françoise', 'Jimes', 'gS4~%N)l!>KW', '9891 Daystar Street', 'Hernani', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('ckime1z@bluehost.com', 'Bénédicte', 'Kime', 'tU6})7{F', null, 'Nemours', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('mecclestone20@spiegel.de', 'Aurélie', 'Ecclestone', 'uF4.zB0`|Vyn', null, 'Pucara', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('raxford21@cpanel.net', 'Anaëlle', 'Axford', 'dF9=P98z', '0309 Jana Avenue', 'Pasar Kidul', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('urenahan22@mapquest.com', 'Andréanne', 'Renahan', 'uC6!7%y)({X/!n', null, 'Barranca de Upía', null, '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('jnajara23@icq.com', 'Maïté', 'Najara', 'aF1>5P?H', null, 'Maribong', null, '5042');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('trickardes24@utexas.edu', 'Desirée', 'Rickardes', 'iL4&m{2_Y\M=6fcC', '8196 Talmadge Trail', 'Ngeru', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('jgear25@google.co.uk', 'Méng', 'Gear', 'mH8%CXOrTW', null, 'Amagbagan', null, '2437');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('jmielnik26@boston.com', 'Lóng', 'Mielnik', 'oG1_Z|4"UP', null, 'Moutas', null, '37008');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('awitterick27@topsy.com', 'Anaëlle', 'Witterick', 'tK7''dT}72', null, 'Ventersburg', null, '9450');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('lheppner28@bizjournals.com', 'Léana', 'Heppner', 'kK2>Z#<Go+_E4Mk3', '32234 Northland Place', 'Sutysky', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('cgateman29@house.gov', 'Agnès', 'Gateman', 'tZ7{|1b0''P+Y', null, 'Kim Sơn', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('hwithur2a@shinystat.com', 'Pénélope', 'Withur', 'eK6~}36b>', '673 Lukken Alley', 'Jiagao', null, '6804');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('bscollard2b@qq.com', 'Marie-thérèse', 'Scollard', 'vD3>Tm<CwM', '485 Moulton Plaza', 'Killam', '427-786-5969', '89980');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('juan.perez@example.com', 'Juan', 'Perez', 'password1', 'Calle Falsa 123', 'Madrid', '600123456', '28001');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('maria.lopez@example.com', 'Maria', 'Lopez', 'password2', 'Avenida Siempreviva 456', 'Madrid', '600654321', '28002');
insert into cliente (mail_cliente, nombre_cliente, apellido_cliente, contrasena_cliente, direccion_cliente, ciudad_cliente, telefono_cliente, codigo_postal_cliente) values ('pedro.garcia@example.com', 'Pedro', 'Garcia', 'password3', 'Calle de la Luna 789', 'Madrid', '600789123', '28003');

-- Drinks --

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (1, 'capuccino', '3.00', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (2, 'latte', '3.00', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (3, 'flat white', '2.80', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (4, 'cortado', '2.30', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (5, 'espresso', '2.00', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (6, 'iced_latte', '3.50', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (7, 'cold_brew', '4.00', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (8, 'matcha', '3.50', null, 'drink', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (9, 'iced_matcha', '4.50', null, 'drink', null, null, null, null, null, null);



-- Bakery 
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (10, 'cookie', '5.00', null, 'bakery', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (11, 'brownie', '5.50', null, 'bakery', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (12, 'croissant', '2.75', null, 'bakery', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (13, 'pain_au_chocolat', '3.00', null, 'bakery', null, null, null, null, null, null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (14, 'banana_bread', '4.00', null, 'bakery', null, null, null, null, null, null);

-- COLOMBIA CHAMBAKÚ --

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (15, 'Colombia Chambaku', '11.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '250gr', 'espresso', 'espresso', 'images/colombiaCh.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (16, 'Colombia Chambaku', '42.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '1kg', 'espresso', 'espresso', 'images/cafeKilo.jpg');
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (17, 'Colombia Chambaku', '11.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '250gr', 'espresso', 'moka', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (18, 'Colombia Chambaku', '42.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '1kg', 'espresso', 'moka', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (19, 'Colombia Chambaku', '11.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '250gr', 'espresso', 'french_press', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (20, 'Colombia Chambaku', '42.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '1kg', 'espresso', 'french_press', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (21, 'Colombia Chambaku', '11.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '250gr', 'espresso', 'V60', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (22, 'Colombia Chambaku', '42.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '1kg', 'espresso', 'V60', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (23, 'Colombia Chambaku', '11.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '250gr', 'espresso', 'aeropress', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (24, 'Colombia Chambaku', '42.50', 'Uno de nuestros cafés más queridos y que deseamos probar cada nueva temporada. Fragancia achocolatada con notas azucaradas y de nueces de California. En boca es dulce y cremoso con un retrogusto largo y agradable a chocolate, pasas y dátiles. Un café muy balanceado y fácil de beber, pero que siempre nos aporta un toque ligeramente ácido y muy divertido que nos hace sonreír en cada taza.', 'retail', null, 'colombia', '1kg', 'espresso', 'aeropress', null);
*/

-- PERÚ CHURUPALLANA --

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (25, 'Peru Churupallana', '12.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '250gr', 'espresso', 'espresso', 'images/peru.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (26, 'Peru Churupallana', '45.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '1kg', 'espresso', 'espresso', 'images/cafeKilo.jpg');
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (27, 'Peru Churupallana', '12.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '250gr', 'espresso', 'moka', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (28, 'Peru Churupallana', '45.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '1kg', 'espresso', 'moka', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (29, 'Peru Churupallana', '12.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '250gr', 'espresso', 'french_press', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (30, 'Peru Churupallana', '45.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '1kg', 'espresso', 'french_press', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (31, 'Peru Churupallana', '12.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '250gr', 'espresso', 'V60', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (32, 'Peru Churupallana', '45.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '1kg', 'espresso', 'V60', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (33, 'Peru Churupallana', '12.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '250gr', 'espresso', 'aeropress', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (34, 'Peru Churupallana', '45.00', 'Nueva cosecha de Churupallana de Perú. Este lote ofrece todo lo que buscamos en nuestro café espresso de la casa: balance, dulzor y jugosidad. Notas achocolatadas y afrutadas que nos recuerdan al chocolate 72% y a las manzanas golden y un retrogusto dulce y cremoso de avellanas. También tiene una acidez suave y un cuerpo ligeramente untuoso.', 'retail', null, 'perú', '1kg', 'espresso', 'aeropress', null);
*/


-- PERÚ LAGUNA  --

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (35, 'Peru Laguna', '13.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '250gr', 'espresso', 'espresso', 'images/LAGUNA.png');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (36, 'Peru Laguna', '52.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '1kg', 'espresso', 'espresso', 'images/cafeKilo.jpg');
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (37, 'Peru Laguna', '13.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '250gr', 'espresso', 'moka', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (38, 'Peru Laguna', '52.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '1kg', 'espresso', 'moka', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (39, 'Peru Laguna', '13.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '250gr', 'espresso', 'french_press', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (40, 'Peru Laguna', '52.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '1kg', 'espresso', 'french_press', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (41, 'Peru Laguna', '13.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '250gr', 'espresso', 'V60', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (42, 'Peru Laguna', '52.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '1kg', 'espresso', 'V60', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (43, 'Peru Laguna', '13.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '250gr', 'espresso', 'aeropress', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (44, 'Peru Laguna', '52.00', 'Un café muy balanceado, limpio y jugoso con sabores clásicos de cacao y chocolate 70%.', 'retail', null, 'perú', '1kg', 'espresso', 'aeropress', null);
*/
-- Colombia el Rosal

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (45, 'Colombia Rosal', '20.50', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '250gr', 'espresso', 'espresso', 'images/rosal.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (46, 'Colombia Rosal', '52.00', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '1kg', 'espresso', 'espresso', 'images/cafeKilo.jpg');
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (47, 'Colombia Rosal', '20.50', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '250gr', 'espresso', 'moka', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (48, 'Colombia Rosal', '52.00', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '1kg', 'espresso', 'moka', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (49, 'Colombia Rosal', '20.50', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '250gr', 'espresso', 'french_press', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (50, 'Colombia Rosal', '52.00', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '1kg', 'espresso', 'french_press', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (51, 'Colombia Rosal', '20.50', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '250gr', 'espresso', 'V60', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (52, 'Colombia Rosal', '52.00', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '1kg', 'espresso', 'V60', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (53, 'Colombia Rosal', '20.50', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '250gr', 'espresso', 'aeropress', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (54, 'Colombia Rosal', '52.00', 'El Rosal Natural es un café muy dulce y de carácter licoroso con notas de cerezas y uvas negras. En boca destaca su cuerpo cremoso con mucho chocolate 70% y notas de frambuesas, una acidez vinosa pero muy balanceada y un retrogusto con notas finales de cacao y frutos rojos.', 'retail', null, 'perú', '1kg', 'espresso', 'aeropress', null);
*/
-- Colombia Descafeinado --


insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (55, 'Colombia Decaf', '13.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '250gr', 'espresso', 'espresso', 'images/descafeinado.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (56, 'Colombia Decaf', '50.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '1kg', 'espresso', 'espresso', 'images/cafeKilo.jpg');
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (57, 'Colombia Decaf', '13.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '250gr', 'espresso', 'moka', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (58, 'Colombia Decaf', '50.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '1kg', 'espresso', 'moka', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (59, 'Colombia Decaf', '13.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado..', 'retail', null, 'perú', '250gr', 'espresso', 'french_press', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (60, 'Colombia Decaf', '50.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '1kg', 'espresso', 'french_press', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (61, 'Colombia Decaf', '13.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '250gr', 'espresso', 'V60', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (62, 'Colombia Decaf', '50.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '1kg', 'espresso', 'V60', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (63, 'Colombia Decaf', '13.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '250gr', 'espresso', 'aeropress', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (64, 'Colombia Decaf', '50.00', 'Más rico de lo que muchos piensan, este Chambakú Descafeinado presenta notas muy balanceadas y dulces de chocolate 80% y azúcar moscovado.', 'retail', null, 'perú', '1kg', 'espresso', 'aeropress', null);
*/

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (65, 'Burundi Kibingo', '18.50', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '250gr', 'espresso', 'espresso', 'images/burundi.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (66, 'Burundi Kibingo', '74.00', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '1kg', 'espresso', 'espresso', 'images/cafeKilo.jpg');
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (67, 'Burundi Kibingo', '18.50', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '250gr', 'espresso', 'moka', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (68, 'Burundi Kibingo', '74.00', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '1kg', 'espresso', 'moka', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (69, 'Burundi Kibingo', '18.50', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas..', 'retail', null, 'perú', '250gr', 'espresso', 'french_press', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (70, 'Burundi Kibingo', '74.00', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '1kg', 'espresso', 'french_press', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (71, 'Burundi Kibingo', '18.50', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '250gr', 'espresso', 'V60', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (72, 'Burundi Kibingo', '74.00', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '1kg', 'espresso', 'V60', null);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (73, 'Burundi Kibingo', '18.50', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '250gr', 'espresso', 'aeropress', null);
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (74, 'Burundi Kibingo', '74.00', 'Brillante y lujoso, este Kibingo Honey viene con bonus: nos aporta todas las características de los buenos cafés lavados de Burundi –aromas a fruta de hueso y fruta deshidratada y sabores dulces y acaramelados– y además el proceso Honey nos deleita con una acidez jugosa con notas de arándanos rojos y fresas.', 'retail', null, 'perú', '1kg', 'espresso', 'aeropress', null);
*/

/*

PLANTILLA CAFES RETAIL

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (35, 'peru_laguna', '13.00', 'Descrip', 'retail', null, 'perú', '250gr', 'espresso', 'espresso');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (36, 'peru_laguna', '52.00', 'Descrip', 'retail', null, 'perú', '1kg', 'espresso', 'espresso');

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (37, 'peru_laguna', '13.00', 'Descrip', 'retail', null, 'perú', '250gr', 'espresso', 'moka');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (38, 'peru_laguna', '52.00', 'Descrip', 'retail', null, 'perú', '1kg', 'espresso', 'moka');

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (39, 'peru_laguna', '13.00', 'Descrip.', 'retail', null, 'perú', '250gr', 'espresso', 'french_press');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (40, 'peru_laguna', '52.00', 'Descrip', 'retail', null, 'perú', '1kg', 'espresso', 'french_press');

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (41, 'peru_laguna', '13.00', 'Descrip', 'retail', null, 'perú', '250gr', 'espresso', 'V60');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (42, 'peru_laguna', '52.00', 'Descrip', 'retail', null, 'perú', '1kg', 'espresso', 'V60');

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (43, 'peru_laguna', '13.00', 'Descrip', 'retail', null, 'perú', '250gr', 'espresso', 'aeropress');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido) values (44, 'peru_laguna', '52.00', 'Descrip', 'retail', null, 'perú', '1kg', 'espresso', 'aeropress');


*/
-- otros productos olvidados de 44 al 80


-- MERCHAN --
/*
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (81, 'Camiseta Ruhido', '26.00', 'Designed by Antony Nate', 'merchandising', 'S', null, null, null, null, 'images/camiseta.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (82, 'Camiseta Ruhido', '26.00', 'Designed by Antony Nate', 'merchandising', 'M', null, null, null, null, 'images/camiseta.jpg');
*/
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (83, 'Camiseta Ruhido', '26.00', 'Designed by Antony Nate', 'merchandising', 'L', null, null, null, null, 'images/camiseta.jpg');

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (84, 'Taza Ruhido', '22.00', '', 'merchandising', null, 'Designed by Clarina Ceramics', null, null, null, 'images/taza.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (85, 'Gorra Ruhido', '16.00', '', 'merchandising', null, 'Designed by Antony Nate', null, null, null, 'images/gorra.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (86, 'Tote Bag', '21.00', '', 'merchandising', null, 'Designed by Antony Nate', null, null, null, 'images/toteBag2.png');

-- COURSES --

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (87, 'curso_espresso', '90.00', 'Si tienes una máquina espresso en casa a la que no sacas el potencial suficiente o tienes intención de comprar una y no sabes por dónde empezar, este taller es para ti.', 'course', null, null, null, null, null, 'images/espresso1.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (88, 'curso_filtro', '90.00', 'Si tienes dificultades o dudas para sacar rendimiento a tus herramientas de filtrado de café de especialidad en casa, este taller es para ti.', 'course', null, null, null, null, null, 'images/filtro1.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (89, 'curso_cata_cafe', '90.00', 'Cata guiada por dos personas de nuestro equipo de formación donde aprenderás paso a paso a catar café de especialidad.
Además de catar los mejores cafés de nuestro menú, también podrás aprender sobre un tema en concreto acerca del café: su origen, los procesos, las variedades… ¡Cada mes trabajaremos una temática diferente! Cada tema se acompañará de un ejercicio práctico donde podrás poner a prueba todo lo aprendido.', 'course', null, null, null, null, null, 'images/catacafe1.jpg');

-- House equipment --

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (90, 'Filtro Hario', '8.00', 'Filtros de papel para tu V60. 100 filtros por paquete.', 'house_equipment', null, null, null, null, null, 'images/filtro1.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (91, 'Bialetti Moka', '35.00', 'Moka Express es el modelo más clásico entre las cafeteras. Fue este café el que hizo famoso al productor italiano Bialetti en la década de 1930. Hasta el día de hoy, es el modelo moka más popular del mundo.', 'house_equipment', null, null, null, null,null, 'images/bialetti2.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (92, 'Fellow Stagg', '190.00', 'Stagg EKG puede ser tu gran aliado en la búsqueda de una taza de café perfecta. Con control de temperatura variable, 1200 vatios para un tiempo de calentamiento rápido y múltiples características para un control más cómodo.', 'house_equipment', null, null, null, null,null, 'images/fellow.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (93, 'Lamarzocco Linea Micra', '990.90', 'Inspirada en la Linea Classic, la Linea Mini viene con doble caldera y un grupo de extracción integrado que permite a la máquina alcanzar la estabilidad térmica y la eficiencia energética del grupo de extracción saturado en un espacio reducido.', 'house_equipment', null, null, null, null,null, 'images/lamarzocco.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (94, 'Fellow Molinillo', '250.90', 'Con este nuevo molinillo de Fellow podrás preparar cualquier tipo de café. Desde un cold brew con su grueso punto de molienda hasta un espresso sin problema alguno ;)', 'house_equipment', null, null, null, null,null, 'images/molinillo.jpg');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (95, 'Aeropress', '42.90', 'AeroPress es una conocida cafetera de filtro con la cual podrás elaborar de 1 a 3 tazas. Es el resultado de combinar el papel de filtro con una prensa de estilo francés. Su funcionamiento es simple, ya que su diseño permite hacer un café excepcional utilizando la presión ejercida por el aire.', 'house_equipment', null, null, null, null,null, 'images/aeropress.jpg');


-- empleados --

insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345671L', 'Bitchip', '1234', 'Carver', 'Dudden', null, '654455499', 'clombard0@wired.com', '7646.93');
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345672L', null, '1234', 'Thornie', 'Claige', 'Alfwy', null, 'talfwy1@altervista.org', '460.00');
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345673L', 'Stim', '1234', 'Valida', 'Goby', null, null, 'vgrewer2@washington.edu', null);
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345674L', 'Tresom', '1234', 'Ezra', 'Barkus', null, '654455410', 'emcallen3@ucoz.com', '1998.11');
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345675L', 'Subin', '1234', 'Angelita', 'Elan', null, null, 'adairton4@answers.com', '161.19');
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345676L', 'Tres-Zap', '1234', 'Sax', 'Skokoe', null, null, 'sdilawey5@parallels.com', '4771.70');
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('12345678A', 'juan.empl', 'emplpass1', 'Juan', 'Perez', 'Garcia', '600123456', 'juan.empleado@example.com', 18000.00);
insert into empleado (DNI_empleado, nick_app, contrasena_empleado, nombre_empleado, apellido_empleado, apellido2_empleado, telefono_empleado, email_empleado, salario_empleado) values ('87654321B', 'maria.empl', 'emplpass2', 'Maria', 'Lopez', 'Martinez', '600654321', 'maria.empleado@example.com', 19000.00);


-- LOCALES --
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('H38', 'Hermosilla 38', 'Madrid', '28001', 'take_away');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('A10', 'Almirante 10', 'Barcelona', '00190', 'take_away');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('PV255', 'Principe Vergara 255', 'Madrid', '28001', 'oficina');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('VA22', 'Victor Armentio 22', 'Madrid', '28001', 'warehouse');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('A255', 'Argentina 255', 'Valencia', '56433', 'cafeteria');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('U56', 'Usera 56', 'Sevilla', '75444', 'take_away');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('AL32', 'Alcalde Lopez 32', 'Bilbao', '87643', 'take_away');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('LC55', 'Lopez Casero 55', 'Donosti', '2329', 'cafeteria');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('S32', 'Soledad 32', 'Madrid', '28001', 'take_away');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('V25', 'Valencia 25', 'Madrid', '28001', 'take_away');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('G66', 'Graciano 66', 'Valencia', '56532', 'cafeteria');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('LOC001', 'Calle Principal 1', 'Madrid', '28001', 'cafeteria');
insert into local (cod_local, direccion_local, ciudad_local, codigo_postal_local, tipo_local) values ('LOC002', 'Avenida Central 2', 'Madrid', '28002', 'cafeteria');


-- Pedidos --  
use ruhido;
insert into pedido (id_pedido, fecha_pedido, fk_mail_cliente, fk_cod_local, precio_total_pedido) values (1, '2023-05-24 22:53:30', 'leila@news.com', 'VA22', '32.90');
insert into pedido (id_pedido, fecha_pedido, fk_mail_cliente, fk_cod_local, precio_total_pedido) values (2, '2023-05-24 12:53:30', null, 'G66', '83.10');
insert into pedido (id_pedido, fecha_pedido, fk_mail_cliente, fk_cod_local, precio_total_pedido) values (3, '2003-05-24 14:00:30', null, 'H38', '10.10');
insert into pedido (id_pedido, fecha_pedido, fk_mail_cliente, fk_cod_local, precio_total_pedido) values (4, '2024-05-01 10:00:00', 'juan.perez@example.com', 'LOC001', 21.50);
insert into pedido (id_pedido, fecha_pedido, fk_mail_cliente, fk_cod_local, precio_total_pedido) values (5, '2024-05-02 11:30:00', 'maria.lopez@example.com', 'LOC002', 11.00);
insert into pedido (id_pedido, fecha_pedido, fk_mail_cliente, fk_cod_local, precio_total_pedido) values (6, '2024-05-03 14:00:00', 'pedro.garcia@example.com', 'LOC001', 31.00);

insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (96, 'Basic Suscription', '30.00', '¿CUÁNDO SE ENVIARÁ? 24/48 h después de tu pedido ¿CUÁNDO TOSTAMOS? Tostamos de lunes a jueves', 'suscription', null, null, null, null,null, 'images/basic.png');
insert into producto (id_producto, nombre_producto, precio_venta, descripcion, categoria_producto, talla, origen_cafe, peso_retail, tueste, molido, url_imagen) values (97, 'Pro Suscription', '60.00', '¿CUÁNDO SE ENVIARÁ? 24/48 h después de tu pedido ¿CUÁNDO TOSTAMOS? Tostamos de lunes a jueves', 'suscription', null, null, null, null,null, 'images/pro.png');


-- pedido producto --

insert into pedido_producto (id_producto_pedido, fk_producto, fk_pedido, cantidad, precio_unidad) values (1, 1, 1, 1, '3');
insert into pedido_producto (id_producto_pedido, fk_producto, fk_pedido, cantidad, precio_unidad) values (2, 2, 2, 1, '5.5');
insert into pedido_producto (id_producto_pedido, fk_producto, fk_pedido, cantidad, precio_unidad) values (3, 3, 3, 5, '2.8');
insert into pedido_producto (fk_producto, fk_pedido, cantidad, precio_unidad) values (96, 4, 2, 10.50);
insert into pedido_producto (fk_producto, fk_pedido, cantidad, precio_unidad) values (97, 4, 1, 3.20);
insert into pedido_producto (fk_producto, fk_pedido, cantidad, precio_unidad) values (98, 6, 1, 7.80);
insert into pedido_producto (fk_producto, fk_pedido, cantidad, precio_unidad) values (96, 5, 1, 10.50);
insert into pedido_producto (fk_producto, fk_pedido, cantidad, precio_unidad) values (97, 6, 2, 3.20);
insert into pedido_producto (fk_producto, fk_pedido, cantidad, precio_unidad) values (98, 6, 1, 7.80);

-- pago 
insert into pago (id_pago, forma_pago, fecha_pago, fk_pedido, total) values (1, 'paypal', '2023-05-24 22:53:30', 1, '32.90');
insert into pago (id_pago, forma_pago, fecha_pago, fk_pedido, total) values (2, 'tarjeta', '2023-05-24 12:53:30', 2, '83.10');
insert into pago (id_pago, forma_pago, fecha_pago, fk_pedido, total) values (3, 'tarjeta', '2003-05-24 14:00:30', 3, '10.10');
insert into pago (forma_pago, fecha_pago, fk_pedido, total) values ('tarjeta', '2024-05-01 10:05:00', 4, 21.50);
insert into pago (forma_pago, fecha_pago, fk_pedido, total) values ('efectivo', '2024-05-02 11:35:00', 5, 11.00);
insert into pago (forma_pago, fecha_pago, fk_pedido, total) values ('paypal', '2024-05-03 14:05:00', 6, 31.00);

-- producto local

insert into producto_local (id_producto_local, fk_producto, fk_cod_local, cantidad_stock) values (1, 1, 'H38', 500);
insert into producto_local (id_producto_local, fk_producto, fk_cod_local, cantidad_stock) values (2, 2, 'G66', 500);
insert into producto_local (id_producto_local, fk_producto, fk_cod_local, cantidad_stock) values (3, 3, 'V25', 500);
insert into producto_local (id_producto_local, fk_producto, fk_cod_local, cantidad_stock) values (4, 4, 'U56', 500);


-- empleado local


insert into empleado_local (id_empleado_local, fk_DNI_empleado, fk_cod_local, puesto_empleado) values (1, '12345671L', 'H38', 'Barista');
insert into empleado_local (id_empleado_local, fk_DNI_empleado, fk_cod_local, puesto_empleado) values (2, '12345672L', 'G66', 'Barista');
insert into empleado_local (id_empleado_local, fk_DNI_empleado, fk_cod_local, puesto_empleado) values (3, '12345673L', 'V25', 'Manager');
insert into empleado_local (id_empleado_local, fk_DNI_empleado, fk_cod_local, puesto_empleado) values (4, '12345674L', 'PV255', 'Marketing');
insert into empleado_local (id_empleado_local, fk_DNI_empleado, fk_cod_local, puesto_empleado) values (5, '12345675L', 'VA22', 'Jefe almacen');


-- suscripciones --


insert into suscripcion (id_suscripcion, tipo_suscripcion, fecha_alta, fecha_vencimiento, precio_suscripcion, fk_mail_cliente) values (1, 'basic', '2023-09-18 10:00:00', '2024-02-16 10:00:00', '25.50', 'leila@news.com');
insert into suscripcion (id_suscripcion, tipo_suscripcion, fecha_alta, fecha_vencimiento, precio_suscripcion, fk_mail_cliente) values (2, 'pro', '2023-07-25 10:00:00', '2023-12-29 10:00:00', '48', 'pablo@google.cn');

ALTER TABLE cliente
ADD COLUMN token VARCHAR(255);