CREATE DATABASE agrosense;
USE agrosense;

CREATE TABLE empresa(
codAtivacao CHAR(6) PRIMARY KEY,
nomeEmpresa VARCHAR(75) NOT NULL,
cnpj CHAR(14) NOT NULL,
dtCadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario(
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
cpf  CHAR(11) UNIQUE,
email VARCHAR(100) UNIQUE,
senha VARCHAR(50),
fkEmpresaUser CHAR(6),
CONSTRAINT fkEmpresaUsuario FOREIGN KEY(fkEmpresaUser)REFERENCES empresa(codAtivacao),
tipo VARCHAR(10)
);

SELECT * FROM usuario;

CREATE TABLE hectare(
idHectare INT PRIMARY KEY AUTO_INCREMENT,
identificacaoHect INT NOT NULL,
fkEmpresaHect CHAR(6),
CONSTRAINT fkEmpresaHectare FOREIGN KEY(fkEmpresaHect) REFERENCES empresa(codAtivacao)
);

CREATE TABLE subArea(
idSubArea INT AUTO_INCREMENT,
identificacaoSub INT,
fkHectare int,
PRIMARY KEY (idSubArea, fkHectare),
CONSTRAINT fkHectare FOREIGN KEY(fkHectare) REFERENCES hectare(idHectare)
);

CREATE TABLE sensor(
idSensor INT PRIMARY KEY AUTO_INCREMENT,
fkSub INT, 
CONSTRAINT fkSubAreaSensor FOREIGN KEY(fkSub) REFERENCES subArea(idSubArea),
dtInstalacao DATE,
statuss INT CONSTRAINT chkStatus
CHECK(statuss IN( '0', '1'))
);

CREATE TABLE medicao(
idMedicao INT PRIMARY KEY AUTO_INCREMENT,
umidade DECIMAL(4,1),
fksensor INT,
CONSTRAINT fkMedicaoSensor FOREIGN KEY(fksensor) REFERENCES sensor(idSensor),
dtMedicao DATETIME
);


-- --------------------------------------- INSERT DAS TABELAS -----------------------------------------


INSERT INTO empresa(codAtivacao, nomeEmpresa, cnpj, dtCadastro) VALUES
( 'E54PG6' ,'v8Tech',  '12345678900001', '2025-02-12'),
( 'CL8P4E','C6 Bank','43345678900004','2025-08-02'),
( 'OEPF9A','Bradesco','12345678940007','2025-05-21'),
( 'SF3HM5','ToTvs','12345678904509', '2025-07-30');

INSERT INTO usuario(nome,cpf,email,senha,fkEmpresaUser, tipo) VALUES
('Pablo','44072454322','Pablo@gmail.com','123456789', 'E54PG6', 'admin'),
('Fagner','32425069251','Fagner@gmail.com','987654321', 'OEPF9A', 'usuario'),
('Arthur','45623678901','Arthur@gmail.com','23456789', 'E54PG6', 'usuario'),
('Ricardo','75261248902','Ricardo@gmail.com','98765432', 'SF3HM5', 'admin'),
('Cesar','45215693219','Cesar@gmail.com','34567891', 'CL8P4E', 'usuario');

INSERT INTO hectare(identificacaoHect, fkEmpresaHect) VALUES
(1, 'E54PG6'),
(2, 'E54PG6'),
(1, 'OEPF9A'),
(2, 'OEPF9A'),
(1,'SF3HM5'),
(2,'SF3HM5'),
(1,'CL8P4E'),
(2,'CL8P4E');

SELECT * FROM hectare;

INSERT INTO subArea(identificacaoSub,fkHectare) VALUES
(1, 1),
(2, 1),
(1, 2),
(2, 2),
(1,3),
(2,3),
(1,4),
(2,4);

SELECT * FROM subArea;

INSERT INTO sensor(fkSub, dtInstalacao, statuss) VALUES
(1, '2022-06-13', 1),
(2, '2022-07-12', 1),
(3, '2022-08-11', 1),
(4, '2022-09-10', 1),
(5, '2023-10-09', 0);

INSERT INTO medicao(fksensor, umidade, dtMedicao) VALUES 
(1, 53, '2025-10-09 08:00:00'),
(1, 54, '2025-10-09 09:00:09'),
(1, 60, '2025-10-09 10:00:00'),
(1, 65, '2025-10-09 11:00:00'),
(1, 67, '2025-10-09 12:00:00'),
(2, 49, '2025-10-09 08:00:00'),
(2, 56, '2025-10-09 09:00:00'),
(2, 56, '2025-10-09 10:00:00'),
(2, 59, '2025-10-09 11:00:00'),
(2, 58, '2025-10-09 12:00:00'),
(3, 76, '2025-10-09 08:00:00'),
(3, 73, '2025-10-09 09:00:00'),
(3, 70, '2025-10-09 10:00:00'),
(3, 62, '2025-10-09 11:00:00'),
(3, 65, '2025-10-09 12:00:00'),
(4, 77, '2025-10-09 08:00:00'),
(4, 81, '2025-10-09 09:00:00'),
(4, 83, '2025-10-09 10:00:00'),
(4, 77, '2025-10-09 11:00:00'),
(4, 75, '2025-10-09 12:00:00');

select * from medicao;


SELECT CONCAT(DATE_FORMAT(m.dtMedicao, '%d-%m-%Y - %H:%i'), ' | ', 'Hectare ', h.identificacaoHect, ' - ', 'Subárea ', sa.identificacaoSub) AS 'Ocorrência' FROM medicao m
	JOIN sensor s ON m.fksensor = s.idSensor
		JOIN subarea sa ON s.fkSub = sa.idSubArea
			JOIN hectare h ON sa.fkHectare = h.idHectare
				JOIN empresa e ON h.fkEmpresaHect = e.codAtivacao
					WHERE m.umidade > 80 OR m.umidade < 60 AND e.codAtivacao = 'OEPF9A'
						LIMIT 7;
				
-- PÁGINA DO INÍCIO
	ALTER VIEW vwAlerta AS
    SELECT
    TIME(m.dtMedicao),
    sa.fkHectare,
    sa.identificacaoSub,
    s.idSensor AS identSensor,
    s.statuss as status
    FROM medicao m
    JOIN sensor s
    ON m.fksensor = s.idSensor
    JOIN subArea sa
	ON s.fkSub = sa.idSubArea
    JOIN hectare ha
    ON ha.idHectare = sa.fkHectare
    JOIN empresa e
    ON ha.fkEmpresaHect = e.codAtivacao
    WHERE ha.fkEmpresaHect = 'E54PG6';
    
    SELECT * from vwAlerta;
    
    ALTER VIEW vwSaude AS
    SELECT (SELECT COUNT(*) FROM sensor WHERE statuss = 0) AS 'Offline', (SELECT COUNT(*) FROM sensor WHERE statuss = 1) AS 'Online';
		
    SELECT * FROM vwSaude;
    
    SELECT * FROM vwAlerta;
    
    ALTER VIEW vwKpiAlerta AS
    SELECT
    DATE_FORMAT(m.dtMedicao, '%d-%m-%Y / %H:%i:%s') as 'Data',
    sa.fkHectare,
    sa.identificacaoSub,
    s.idSensor AS identSensor
    FROM medicao m
    JOIN sensor s
    ON m.fksensor = s.idSensor
    JOIN subArea sa
	ON s.fkSub = sa.idSubArea
    JOIN hectare ha
    ON ha.idHectare = sa.fkHectare
    JOIN empresa e
    ON ha.fkEmpresaHect = e.codAtivacao
    WHERE umidade > 80 OR umidade < 60 AND ha.fkEmpresaHect = 'E54PG6'
     ORDER BY dtMedicao DESC LIMIT 1;
     
    SELECT * FROM vwKpiAlerta;

       CREATE VIEW vwEvolucao AS
SELECT
    h.identificacaoHect AS Hectare,
    sa.identificacaoSub AS SubArea,
    m.umidade AS Medição,
    TIME(m.dtMedicao) AS Hora
FROM hectare h 
JOIN subArea sa
    ON h.idHectare = sa.fkHectare
JOIN sensor s
    ON s.fkSubArea = sa.idSubArea AND s.fkSubHect = sa.fkHectare
JOIN medicao m 
    ON m.fksensor = s.idSensor;
    SELECT * FROM vwEvolucao;
------------------------------------------------------------------------------------
    
-- HECTARE
    
    ALTER VIEW vwumidadesub AS
    SELECT s.fkSub,
        AVG(m.umidade)
        FROM sensor AS s JOIN medicao AS m
        ON s.idSensor = m.fkSensor
        GROUP BY s.fkSub;
        
        SELECT * FROM vwumidadesub;
    
-------------------------------------------------------
    
    
-- SUBÁREA

ALTER VIEW vwMediaSub AS
SELECT 
    sa.idSubArea,
    sa.identificacaoSub,
    ROUND(AVG(m.umidade), 1)    AS umidade_media,
    MAX(m.umidade)    AS maiorUmidade,
    MIN(m.umidade)    AS menorUmidade
FROM medicao m
JOIN sensor s
    ON m.fksensor = s.idSensor
JOIN subArea sa
    ON s.fkSubArea = sa.idSubArea
    AND s.fkSubHect = sa.fkHectare
    WHERE DATE(m.dtMedicao) = (SELECT CURDATE())
GROUP BY sa.idSubArea, sa.identificacaoSub;

SELECT CURDATE();
    select * from vwMediaSub;

-------------------------------------------------------------------
    