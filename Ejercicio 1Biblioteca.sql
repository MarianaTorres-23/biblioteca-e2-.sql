CREATE DATABASE biblioteca_escolar;
USE biblioteca_escolar;


CREATE TABLE ALUMNO (
id_alumno INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
grupo VARCHAR(20) NOT NULL,
correo VARCHAR(100) NOT NULL
);


CREATE TABLE LIBRO (
id_libro INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(150) NOT NULL,
autor VARCHAR(100) NOT NULL,
editorial VARCHAR(100) NOT NULL,
estado ENUM('Disponible','Prestado') NOT NULL
);

ALTER TABLE LIBRO
ADD categoria VARCHAR(50);

CREATE TABLE BIBLIOTECARIO (
id_bibliotecario INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
turno ENUM('Matutino','Vespertino') NOT NULL,
correo VARCHAR(100) NOT NULL
);


CREATE TABLE PRESTAMO (
id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
fecha_prestamo DATE NOT NULL,
fecha_devolucion DATE,
estado ENUM('Activo','Devuelto') NOT NULL,
id_alumno INT NOT NULL,
id_libro INT NOT NULL,
id_bibliotecario INT NOT NULL,
FOREIGN KEY (id_alumno) REFERENCES ALUMNO(id_alumno),
FOREIGN KEY (id_libro) REFERENCES LIBRO(id_libro),
FOREIGN KEY (id_bibliotecario) REFERENCES BIBLIOTECARIO(id_bibliotecario)
);

CREATE TABLE EMPLEADO (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    turno VARCHAR(20),
    puesto VARCHAR(50)
);

CREATE INDEX idx_libro_estado ON LIBRO(estado);
CREATE INDEX idx_prestamo_alumno ON PRESTAMO(id_alumno);

EXPLAIN SELECT * FROM LIBRO WHERE estado = 'Disponible';
EXPLAIN SELECT * FROM PRESTAMO WHERE id_alumno = 1;

INSERT INTO ALUMNO (nombre, grupo, correo)
VALUES ('Ana Martínez', '3A', 'ana@escuela.com');

INSERT INTO ALUMNO (nombre, grupo, correo)
VALUES ('Luis Herrera', '3B', 'luis@escuela.com');

INSERT INTO EMPLEADO (nombre, turno, puesto)
VALUES ('María López', 'Matutino', 'Bibliotecaria');

INSERT INTO EMPLEADO (nombre, turno, puesto)
VALUES ('Carlos Ruiz', 'Vespertino', 'Auxiliar');

INSERT INTO LIBRO (titulo, autor, editorial)
VALUES ('El principito', 'Antoine de Saint-Exupéry', 'Salamandra');

INSERT INTO LIBRO (titulo, autor, editorial)
VALUES ('Don Quijote', 'Miguel de Cervantes', 'Espasa');

INSERT INTO LIBRO (titulo, autor, editorial)
VALUES ('Matemáticas 1', 'Juan Pérez', 'Trillas');

INSERT INTO PRESTAMO
(fecha_prestamo, fecha_devolucion, estado, id_alumno, id_libro, id_bibliotecario)
VALUES
('2026-02-20', '2026-02-27', 'Activo', 1, 1, 1);

INSERT INTO BIBLIOTECARIO (nombre, turno, correo)
VALUES ('María López', 'Matutino', 'maria@escuela.com');
SELECT * FROM BIBLIOTECARIO;
INSERT INTO PRESTAMO
(fecha_prestamo, fecha_devolucion, estado, id_alumno, id_libro, id_bibliotecario)
VALUES
('2026-02-20', '2026-02-27', 'Activo', 1, 1, 1);

INSERT INTO PRESTAMO
(fecha_prestamo, fecha_devolucion, estado, id_alumno, id_libro, id_bibliotecario)
VALUES
('2026-02-20', '2026-02-25', 'Activo', 2, 2, 1);

INSERT INTO DETALLE_PRESTAMO (id_prestamo, id_libro, cantidad)
VALUES (1, 1, 1);

INSERT INTO PRESTAMO
(fecha_prestamo, fecha_devolucion, estado, id_alumno, id_libro, id_bibliotecario)
VALUES
('2026-03-01', '2026-03-08', 'Activo', 1, 2, 1);

UPDATE LIBRO
SET estado = 'Prestado'
WHERE id_libro = 1;

UPDATE ALUMNO
SET correo = 'ana_actualizado@escuela.com'
WHERE id_alumno = 1;

UPDATE PRESTAMO
SET estado = 'Devuelto'
WHERE id_prestamo = 1;

DELETE FROM LIBRO
WHERE id_libro = 5;

DELETE FROM PRESTAMO
WHERE id_prestamo = 10;

SELECT * FROM LIBRO;

SELECT titulo, autor
FROM LIBRO;

SELECT * FROM LIBRO
WHERE estado = 'Disponible';

SELECT * FROM ALUMNO
ORDER BY nombre ASC;

SELECT * FROM PRESTAMO
WHERE estado = 'Activo'
ORDER BY fecha_prestamo DESC;

SELECT 
    P.id_prestamo,
    A.nombre AS alumno,
    P.fecha_prestamo,
    P.estado
FROM PRESTAMO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno;

SELECT 
    P.id_prestamo,
    A.nombre AS alumno,
    L.titulo AS libro,
    B.nombre AS bibliotecario,
    P.fecha_prestamo
FROM PRESTAMO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno
JOIN LIBRO L ON P.id_libro = L.id_libro
JOIN BIBLIOTECARIO B ON P.id_bibliotecario = B.id_bibliotecario;

SELECT nombre
FROM ALUMNO
WHERE id_alumno = (
    SELECT id_alumno
    FROM PRESTAMO
    GROUP BY id_alumno
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

SELECT titulo
FROM LIBRO
WHERE id_libro IN (
    SELECT id_libro
    FROM PRESTAMO
    WHERE estado = 'Activo'
);

SELECT COUNT(*) AS total_prestamos
FROM PRESTAMO;

SELECT COUNT(*) AS prestamos_activos
FROM PRESTAMO
WHERE estado = 'Activo';

SELECT MAX(fecha_prestamo) AS ultimo_prestamo
FROM PRESTAMO;

SELECT 
    A.nombre,
    COUNT(P.id_prestamo) AS total_prestamos
FROM PRESTAMO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno
GROUP BY A.nombre;

SELECT 
    A.nombre,
    COUNT(P.id_prestamo) AS total_prestamos
FROM PRESTAMO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno
GROUP BY A.nombre
HAVING COUNT(P.id_prestamo) > 1;