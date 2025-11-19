CREATE DATABASE agrosense;
USE agrosense;

drop database agrosense;

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

CREATE TABLE hectare(
idHectare INT PRIMARY KEY AUTO_INCREMENT,
identificacaoHect INT NOT NULL,
fkEmpresaHect CHAR(6),
CONSTRAINT fkEmpresaHectare FOREIGN KEY(fkEmpresaHect) REFERENCES empresa(codAtivacao)
);

CREATE TABLE subArea(
idSubArea INT,
identificacaoSub INT,
fkHectare int,
PRIMARY KEY (idSubArea,identificacaoSub, fkHectare),
CONSTRAINT fkHectare FOREIGN KEY(fkHectare) REFERENCES hectare(idHectare)
);

CREATE TABLE sensor(
idSensor INT PRIMARY KEY AUTO_INCREMENT,
fkSubArea INT, 
CONSTRAINT fkSubAreaSensor FOREIGN KEY(fkSubArea) REFERENCES subArea(idSubArea),
fkSubHect INT,
CONSTRAINT fkSubAreaHectRegra FOREIGN KEY (fkSubHect) REFERENCES subArea(fkHectare),
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
(1, 'SF3HM5'),
(1, 'E54PG6'),
(1, 'OEPF9A');

INSERT INTO subArea(idSubArea,identificacaoSub,fkHectare) VALUES
(1, 1, 1),
(2, 2, 1),
(1, 1, 2),
(2, 2, 2),
(1, 1, 3),
(2, 2, 3),
(1, 1, 4),
(2, 2, 4);

INSERT INTO sensor(fkSubArea, fkSubHect, dtInstalacao, statuss) VALUES
(1, 1, '2022-06-13', 0),
(2, 1, '2022-07-12', 1),
(1, 2, '2022-08-11', 1),
(2, 2, '2022-09-10', 0),
(1, 3, '2023-10-09', 0),
(2, 3, '2023-11-08', 1),
(1, 4, '2024-03-02', 1),
(2, 4, '2024-04-04', 0);

INSERT INTO medicao(fksensor, umidade, dtMedicao) VALUES 
(1, 60, null),
(2, 89, null),
(3, 70, null),
(4, 83, null),
(5, 55, '2025-10-09 12:30:05'),
(6, 50, '2025-10-09 12:30:05'),
(7, 75, null),
(8, 47, '2025-10-09 12:30:05');


-- PÁGINA DO INÍCIO
	ALTER VIEW vwAlerta AS
    SELECT
    m.dtMedicao as 'Data',
    sa.fkHectare,
    sa.identificacaoSub,
    s.idSensor AS identSensor,
    s.statuss as status
    FROM medicao m
    JOIN sensor s
    ON m.fksensor = s.idSensor
    JOIN subArea sa
	ON s.fkSubArea = sa.idSubArea
    JOIN hectare ha
    ON s.fkSubHect = ha.idHectare
    WHERE umidade > 80 OR umidade < 60;
    SELECT * FROM vwAlerta;
    
    CREATE VIEW vwKpiAlerta AS
    SELECT
    m.dtMedicao as 'Data',
    sa.fkHectare,
    sa.identificacaoSub,
    s.idSensor AS identSensor,
    s.statuss as status
    FROM medicao m
    JOIN sensor s
    ON m.fksensor = s.idSensor
    JOIN subArea sa
	ON s.fkSubArea = sa.idSubArea
    JOIN hectare ha
    ON s.fkSubHect = ha.idHectare
    WHERE umidade > 80 OR umidade < 60
     ORDER BY dtMedicao DESC LIMIT 1;
    SELECT * FROM vwKpiAlerta;

       ALTER VIEW vwEvolucao AS
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
    

    CREATE VIEW vwumidadesub AS
    SELECT s.fkSubArea,
		s.fkSubHect,
        m.umidade
        FROM sensor AS s JOIN medicao AS m
        ON s.idSensor = m.fkSensor;
        SELECT * FROM vwumidadesub;
    
-------------------------------------------------------
    
    
-- SUBÁREA

ALTER VIEW vwMediaSub AS
SELECT 
    sa.idSubArea,
    sa.identificacaoSub,
    AVG(m.umidade)    AS umidade_media,
    MAX(m.umidade)    AS maiorUmidade,
    MIN(m.umidade)    AS menorUmidade
FROM medicao m
JOIN sensor s
    ON m.fksensor = s.idSensor
JOIN subArea sa
    ON s.fkSubArea = sa.idSubArea
    AND s.fkSubHect = sa.fkHectare
GROUP BY sa.idSubArea, sa.identificacaoSub;


    select * from vwMediaSub;

-------------------------------------------------------------------
    