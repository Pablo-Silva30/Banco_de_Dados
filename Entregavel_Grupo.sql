USE agrosense;

CREATE TABLE empresa(
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nomeEmpresa VARCHAR(75) NOT NULL,
cnpj CHAR(14) NOT NULL,
codAtivacao VARCHAR(15),
dtCadastro DATETIME DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE usuario(
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
cpf  VARCHAR(11),
email VARCHAR(100) NOT NULL UNIQUE,
CONSTRAINT chkEmail CHECK(email LIKE '%@%'),
senha VARCHAR(50) NOT NULL,
fkEmpresaUser INT,
CONSTRAINT fkEmpresaUsuario FOREIGN KEY(fkEmpresaUser)REFERENCES empresa(idEmpresa)
);

CREATE TABLE hectare(
idHectare INT PRIMARY KEY AUTO_INCREMENT,
nomeHectare VARCHAR(45) NOT NULL,
kgPlantada INT NOT NULL,
fkEmpresaHect INT,
CONSTRAINT fkEmpresaHectare FOREIGN KEY(fkEmpresaHect) REFERENCES empresa(idEmpresa)
);

CREATE TABLE subArea(
idSubArea INT,
nomeArea VARCHAR(45),
fkHectare int,
PRIMARY KEY (idSubArea, fkHectare),
CONSTRAINT fkHectare FOREIGN KEY(fkHectare) REFERENCES hectare(idHectare)
);

CREATE TABLE sensor(
idSensor INT PRIMARY KEY AUTO_INCREMENT,
subArea_id INT, 
CONSTRAINT fkSubAreaSensor FOREIGN KEY(subArea_id) REFERENCES subArea(idSubArea),
fkSubHect INT,
CONSTRAINT fkSubAreaHectRegra FOREIGN KEY (fkSubHect) REFERENCES subArea(fkHectare),
dtInstalacao DATE
);

CREATE TABLE medicao(
idMedicao INT PRIMARY KEY AUTO_INCREMENT,
umidade DECIMAL(4,1),
fksensor INT,
CONSTRAINT fkMedicaoSensor FOREIGN KEY(fksensor) REFERENCES sensor(idSensor),
dtMedicao DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- --------------------------------------- INSERT DAS TABELAS -----------------------------------------


INSERT INTO empresa(nomeEmpresa, cnpj,codAtivacao, dtCadastro) VALUES
('v8Tech',  '12345678900001', 'v812345', '2025-02-12'),
('C6 Bank','43345678900004','c612345','2025-08-02'),
('Bradesco','12345678940007','bra12345','2025-05-21'),
('ToTvs','12345678904509','totvs12345','2025-07-30');

INSERT INTO usuario(nome,cpf,email,senha,fkEmpresaUser) VALUES
('Pablo','44072454322','Pablo@gmail.com','123456789',1),
('Fagner','32425069251','Fagner@gmail.com','987654321',3),
('Arthur','45623678901','Arthur@gmail.com','23456789',1),
('Ricardo','75261248902','Ricardo@gmail.com','98765432',4),
('Cesar','45215693219','Cesar@gmail.com','34567891',2);

INSERT INTO hectare(nomeHectare,kgPlantada,fkEmpresaHect) VALUES
('Hectare 1', 400, 3),
('Hectare 1', 450, 4),
('Hectare 1', 600, 1),
('Hectare 1', 573, 2);

INSERT INTO subArea(idSubArea,nomeArea,fkHectare) VALUES
(1, 'SubÁrea 1', 1),
(2, 'SubÁrea 2', 1),
(1, 'SubÁrea 1', 2),
(2, 'SubÁrea 2', 2),
(1, 'SubÁrea 1', 3),
(2, 'SubÁrea 2', 3),
(1, 'SubÁrea 1', 4),
(2, 'SubÁrea 2', 4);

INSERT INTO sensor(subArea_id, fkSubHect, dtInstalacao) VALUES
(1, 1, '2022-06-13'),
(2, 1, '2022-07-12'),
(1, 2, '2022-08-11'),
(2, 2, '2022-09-10'),
(1, 3, '2023-10-09'),
(2, 3, '2023-11-08'),
(1, 4, '2024-03-02'),
(2, 4, '2024-04-04');

INSERT INTO medicao(fksensor, umidade) VALUES 
(1, 10),
(2, 10),
(3, 10),
(4, 10),
(5, 10),
(6, 10),
(7, 10),
(8, 10);

SELECT
e.nomeEmpresa as Empresa,
f.nome as 'Funcionário Responsável',
h.nomeHectare as Hectare,
CONCAT(h.kgPlantada, 'kg') as 'KgPlantadas',
sa.nomeArea as Área,
s.idSensor as Sensor,
-- m.umidade,
s.dtInstalacao as 'Data de Instalação'
FROM  sensor as s
JOIN 
    subArea as sa ON s.subArea_id = sa.idSubArea AND s.fkSubHect = sa.fkHectare
JOIN 
    hectare AS h ON sa.fkHectare = h.idHectare
JOIN 
empresa as e on e.idEmpresa = h.fkEmpresaHect
JOIN
usuario as f on idEmpresa = f.fkEmpresaUser;