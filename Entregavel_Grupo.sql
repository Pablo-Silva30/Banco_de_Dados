DROP DATABASE agrosense;
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
CONSTRAINT fkEmpresaUsuario FOREIGN KEY(fkEmpresaUser)REFERENCES empresa(codAtivacao)
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
dtInstalacao DATETIME DEFAULT current_timestamp,
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
DESC empresa;

INSERT INTO empresa (codAtivacao, nomeEmpresa, cnpj, dtCadastro) VALUES
	('XPTO99', 'OPTX Batatas', '1234567891234', '2025-11-03');
    
DESC sensor;

INSERT INTO hectare (identificacaoHect, fkEmpresaHect) VALUES
	(1, 'XPTO99');
    
INSERT INTO subarea (identificacaoSub, fkHectare) VALUES
	(1, 1),
	(2, 1);
    
INSERT INTO sensor (fkSub, statuss) VALUES
	(1, 1),
	(2, 0);
    
SELECT * FROM medicao;

ALTER VIEW vwalertas AS
SELECT CONCAT(DATE_FORMAT(m.dtMedicao, '%d-%m-%Y - %H:%i'), ' | ', 'Hectare ', h.identificacaoHect, ' - ', 'Subárea ', sa.identificacaoSub) AS 'Ocorrência' FROM medicao m
	JOIN sensor s ON m.fksensor = s.idSensor
		JOIN subarea sa ON s.fkSub = sa.idSubArea
			JOIN hectare h ON sa.fkHectare = h.idHectare
				JOIN empresa e ON h.fkEmpresaHect = e.codAtivacao
					WHERE m.umidade > 80 OR m.umidade < 60 AND e.codAtivacao = 'XPTO99'
						ORDER BY idMedicao DESC LIMIT 7;
	
    SELECT * FROM vwalertas;
    
    ----------------------------------------------------------------------------------- 
    
    ALTER VIEW vwSaude AS
    SELECT (SELECT COUNT(*) FROM sensor WHERE statuss = 0) AS 'Offline', (SELECT COUNT(*) FROM sensor WHERE statuss = 1) AS 'Online';
    

-----------------------------------------------------------------------------------
    
    ALTER VIEW vwKpis AS 
    SELECT 
    (SELECT m.umidade FROM medicao AS m ORDER BY m.idMedicao DESC LIMIT 1) as umiatual,
    (SELECT MAX(m.umidade) FROM medicao AS m LIMIT 1) AS maxumi,
    (SELECT DATE_FORMAT(m.dtMedicao, '%Hh%i') FROM medicao m
	WHERE m.umidade = (SELECT MAX(m.umidade) FROM medicao m) LIMIT 1) AS hrMax,
    (SELECT MIN(m.umidade) FROM medicao AS m LIMIT 1) as minumi,
	(SELECT COUNT(*) FROM vwAlertas)as qtdOcorrencia,
	(SELECT DATE_FORMAT(m.dtMedicao, '%Hh%i') FROM medicao m
	WHERE m.umidade = (SELECT MIN(m.umidade) FROM medicao m) LIMIT 1) AS hrMin
    FROM medicao AS m JOIN sensor s ON m.fksensor = s.idSensor
		JOIN subarea sa ON s.fkSub = sa.idSubArea
			JOIN hectare h ON sa.fkHectare = h.idHectare
				JOIN empresa e ON h.fkEmpresaHect = e.codAtivacao
                WHERE e.codAtivacao = 'XPTO99'
                GROUP BY m.umidade
					ORDER BY m.umidade LIMIT 1;
                
                
SELECT * FROM vwKpis;
    
   