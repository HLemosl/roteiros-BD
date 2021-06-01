/* Este Banco de dados mesmo sendo interligado, pode ser visto divido em duas partes, onde na primeira parte são as informações do seguro, e na segunda parte as informações para casos de ocorrência de um sinistro. 
	Na primeira parte podemos ver uma associação de informações entre o automóvel, o segurado e o seguro; porem suas informações estão separadas em tabelas diferentes, mas estão associadas por identificadores unicos. Na tabela automóvel temos as informações do veículo, o seu proprietário (podendo ser diferente do segurado), uma identificação se este veículo possui algum seguro ativo e a identificação do seu seguro. Na tabela segurado, informações do contratante do seguro referenciando o automóvel que este está contratando. Na tabela seguro, temos informações específicas sobre o seguro contratado, junto sua data de inicio e fim.
	Na segunda parte da tabela podemos ver um conjunto de informações a serem preenchidos em casos de sinistro, enbora em tabela separadas, grande parte se unifica em pericia. Na tabela oficina, temos as informações das oficinas disponiveis para atendimento. Na tabela perito, informações dos peritos que trabalham para aquela oficina. Na tabela pericia, temos os conjunto de informações sobre a análise da ocorrência de um determinado sinistro. Na tabela sinistro, informamos sobre o caso do sinistro reunindo informações do caso, e um referenciamento da oficina que fará o restante da análise. Na tabela reparo, catalogamos o conjunto de pericias realizadas e os gastos que a seguradora teve.*/

-- (2)Após o desenvolvimentos das definições das tabelas a serem criadas no banco de dados, iniciaremos a criação delas:

CREATE TABLE automovel (
	marca VARCHAR(20),
	modelo VARCHAR(60),
	ano INTEGER,
	placa CHAR(7),
	renavam VARCHAR(11),
	chassi VARCHAR(17),
	proprietário VARCHAR(70),
	seguro BOOLEAN,
	id_seguro INTEGER
);
CREATE TABLE segurado (
	nome VARCHAR(70),
	cpf VARCHAR(11),
	telefone VARCHAR(20),
	email VARCHAR(50),	
	automóvel VARCHAR(11),
	banco VARCHAR(20),
	conta VARCHAR(6),
	agência VARCHAR(4)	
);
CREATE TABLE seguro (
	id SERIAL,
	início DATE,
	fim DATE,
	franquia NUMERIC,
	características TEXT,
	valor NUMERIC
);
CREATE TABLE sinistro (
	situação TEXT,
	comunicante VARCHAR(70),
	telefone VARCHAR(20),
	oficina INTEGER,
	classificação VARCHAR(100),
	data_hora TIMESTAMP,
	localização VARCHAR(150),
	Id_seguro INTEGER
);
CREATE TABLE oficina (
	id SERIAL,
	nome VARCHAR(70),
	endereço VARCHAR(150),
	telefone VARCHAR(20)
);
CREATE TABLE pericia (
	id SERIAL,
	data_hora TIMESTAMP,
	perito INTEGER,
	oficina INTEGER,
	placa VARCHAR(7),
	orçamento NUMERIC,
	relatório TEXT
);
CREATE TABLE perito (
	id SERIAL,
	nome VARCHAR(70),
	cpf VARCHAR(11),
	telefone VARCHAR(20),
	email VARCHAR(50)
);
CREATE TABLE reparo (
	pericia INTEGER,
	valor NUMERIC
);

-- (3)Definição das chaves primárias das tabelas:
ALTER TABLE automovel ADD PRIMARY KEY (renavam);
ALTER TABLE segurado ADD PRIMARY KEY (cpf);
ALTER TABLE seguro ADD PRIMARY KEY (id);
ALTER TABLE oficina ADD PRIMARY KEY (id);
ALTER TABLE pericia ADD PRIMARY KEY (id);
ALTER TABLE perito ADD PRIMARY KEY (id);


-- (4)Definição das chaves estrangeiras das tabelas:
ALTER TABLE automovel ADD CONSTRAINT automovel_idseguro_fkey FOREIGN KEY (id_seguro) REFERENCES seguro(id);
ALTER TABLE segurado ADD CONSTRAINT segurado_automovel_fkey FOREIGN KEY (automovel) REFERENCES altomovel(renavam);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_oficina_fkey FOREIGN KEY (oficina) REFERENCES oficina(id);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_idseguro_fkey FOREIGN KEY (id_seguro) REFERENCES seguro(id);
ALTER TABLE pericia ADD CONSTRAINT pericia_perito_fkey FOREIGN KEY (perito) REFERENCES perito(id);
ALTER TABLE pericia ADD CONSTRAINT pericia_oficina_fkey FOREIGN KEY (oficina) REFERENCES oficina(id);
ALTER TABLE reparo ADD CONSTRAINT reparo_pericia_fkey FOREIGN KEY (pericia) REFERENCES pericia(id);

-- (5)Pensando em novos atributos que poderiam ser úteis:
	-- Em 'automovel' poderia ser adicionado o atributo de CNH do proprietário do carro, caso ele tenha ou não, pois dependendo da ocorrência do sinistro, o seguro pode verificar se o seguro se adequa para aquela eventualidade; um exemplo de um caso NOT NULL.
	-- Em 'seguro' poderia ser adicionado um atributo de verificação do pagamento do seguro, em casos em que o pagamento for parcelado ou via boleto, para recorrer ao segurado antes que o seguro seja cancelado por falta de pagamento.

-- (6)Removendo todas as tabelas:
DROP TABLE automovel, segurado, seguro, sinistro, oficina, pericia, perito, reparo;

-- (7)(8)Escrevendo e Criando tabelas com as definições de constraints:
CREATE TABLE seguro (
	id SERIAL,
	inicio DATE NOT NULL,
	fim DATE NOT NULL,
	franquia NUMERIC NOT NULL,
	características TEXT NOT NULL,
	valor NUMERIC NOT NULL,
	PRIMARY KEY (id)
);
CREATE TABLE automovel (
	marca VARCHAR(20),
	modelo VARCHAR(60),
	ano INTEGER,
	placa CHAR(7) NOT NULL,
	renavam VARCHAR(11) NOT NULL,
	chassi VARCHAR(17),
	proprietário VARCHAR(70) NOT NULL,
	seguro BOOLEAN,
	id_seguro INTEGER NOT NULL,
	PRIMARY KEY (renavam),
	CONSTRAINT automovel_idseguro_fkey FOREIGN KEY (id_seguro) REFERENCES seguro(id)
);
CREATE TABLE segurado (
	nome VARCHAR(70) NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(50),
	automovel VARCHAR(11) NOT NULL,
	banco VARCHAR(20),
	conta VARCHAR(6) NOT NULL,
	agência VARCHAR(4) NOT NULL,
	PRIMARY KEY (cpf),
	CONSTRAINT segurado_automovel_fkey FOREIGN KEY (automovel) REFERENCES automovel(renavam)
);
CREATE TABLE oficina (
	id SERIAL,
	nome VARCHAR(70) NOT NULL,
	endereço VARCHAR(150) NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	PRIMARY KEY (id)
);
CREATE TABLE sinistro (
	situação TEXT NOT NULL,
	comunicante VARCHAR(70) NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	oficina INTEGER NOT NULL,
	classificação VARCHAR(100),
	data_hora TIMESTAMP NOT NULL,
	localização VARCHAR(150) NOT NULL,
	id_seguro INTEGER NOT NULL,
	CONSTRAINT sinistro_oficina_fkey FOREIGN KEY (oficina) REFERENCES oficina(id),
	CONSTRAINT sinistro_idseguro_fkey FOREIGN KEY (id_seguro) REFERENCES seguro(id)
);
CREATE TABLE perito (
	id SERIAL,
	nome VARCHAR(70) NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(50),
	PRIMARY KEY (id)
);
CREATE TABLE pericia (
	id SERIAL,
	data_hora TIMESTAMP NOT NULL,
	perito INTEGER NOT NULL,
	oficina INTEGER NOT NULL,
	placa VARCHAR(7) NOT NULL,
	orçamento NUMERIC NOT NULL,
	relatório TEXT NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT pericia_perito_fkey FOREIGN KEY (perito) REFERENCES perito(id),
	CONSTRAINT pericia_oficina_fkey FOREIGN KEY (oficina) REFERENCES oficina(id)
);
CREATE TABLE reparo (
	pericia INTEGER,
	valor NUMERIC,
	CONSTRAINT reparo_pericia_fkey FOREIGN KEY (pericia) REFERENCES pericia(id)
);

-- (9)Removendo todas as tabelas:
DROP TABLE reparo, pericia, perito, sinistro, oficina, segurado, automovel, seguro;

-- (10)Adicionando novas ideias de tabelas para o banco de dados:
	-- Uma tabela que exibe os tipos de seguro junto com suas características e referenciando um identificador de outra tabela que classifica os tipos de sinistro que este seguro atende, tornando mais organizado estas informações e para decidir se o seguro atende aquele caso de sinistro.
	-- Uma tabela com os dados do proprietário do carro, caso ele não for o segurado, para identificar melhor que é o responsável pelo automóvel.
