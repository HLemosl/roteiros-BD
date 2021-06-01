--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_medicamento_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_id_entrega_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_id_cliente_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_funcionario_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT remove_medicamento_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT remove_funcionario_fkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_farmacia_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_funcionario_fkey;
ALTER TABLE ONLY public.enderecos DROP CONSTRAINT enderecos_id_cliente_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT sede_unica_chk;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_gerente_key;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_bairro_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE public.vendas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entregas ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.vendas_id_seq;
DROP TABLE public.vendas;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP TABLE public.farmacias;
DROP SEQUENCE public.entregas_id_seq;
DROP TABLE public.entregas;
DROP TABLE public.enderecos;
DROP TABLE public.clientes;
DROP TYPE public.estados;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estados; Type: TYPE; Schema: public; Owner: henriquell
--

CREATE TYPE public.estados AS ENUM (
    'PB',
    'AL',
    'RN',
    'PE',
    'SE',
    'BH',
    'PI',
    'MA',
    'CE'
);


ALTER TYPE public.estados OWNER TO henriquell;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.clientes (
    cpf character(11) NOT NULL,
    nome character varying(64) NOT NULL,
    data_de_nascimento date NOT NULL,
    telefone character(11) NOT NULL,
    CONSTRAINT verifica_idade CHECK ((date_part('year'::text, age((data_de_nascimento)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.clientes OWNER TO henriquell;

--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.enderecos (
    id_cliente character(11) NOT NULL,
    categoria character varying(18) NOT NULL,
    rua character varying(100) NOT NULL,
    "número" character(10) NOT NULL,
    bairro character(40) NOT NULL,
    cidade character(40) NOT NULL,
    estado public.estados NOT NULL,
    complemento character varying(40),
    cep character(8),
    CONSTRAINT verifica_categoria CHECK ((((categoria)::text = 'residência'::text) OR ((categoria)::text = 'trabalho'::text) OR ((categoria)::text = 'outro'::text)))
);


ALTER TABLE public.enderecos OWNER TO henriquell;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.entregas (
    id integer NOT NULL,
    funcionario character(11) NOT NULL,
    localizacao character varying(18) NOT NULL,
    id_cliente character(11) NOT NULL
);


ALTER TABLE public.entregas OWNER TO henriquell;

--
-- Name: entregas_id_seq; Type: SEQUENCE; Schema: public; Owner: henriquell
--

CREATE SEQUENCE public.entregas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregas_id_seq OWNER TO henriquell;

--
-- Name: entregas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: henriquell
--

ALTER SEQUENCE public.entregas_id_seq OWNED BY public.entregas.id;


--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.farmacias (
    id integer NOT NULL,
    bairro character varying(40) NOT NULL,
    cidade character varying(40) NOT NULL,
    estado public.estados NOT NULL,
    telefone character(11) NOT NULL,
    sede_filial character(1) NOT NULL,
    gerente character(11) NOT NULL,
    CONSTRAINT sede_filial_valido_chk CHECK (((sede_filial = 'S'::bpchar) OR (sede_filial = 'F'::bpchar)))
);


ALTER TABLE public.farmacias OWNER TO henriquell;

--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.funcionarios (
    cpf character(11) NOT NULL,
    nome character varying(64) NOT NULL,
    data_de_nascimento date NOT NULL,
    telefone character(11) NOT NULL,
    unidade integer,
    funcao character(1) NOT NULL,
    gerente boolean NOT NULL,
    CONSTRAINT funcao_valida_chk CHECK (((funcao = 'F'::bpchar) OR (funcao = 'V'::bpchar) OR (funcao = 'E'::bpchar) OR (funcao = 'C'::bpchar) OR (funcao = 'A'::bpchar))),
    CONSTRAINT gerente_valido_chk CHECK ((((gerente = true) AND ((funcao = 'A'::bpchar) OR (funcao = 'F'::bpchar))) OR (gerente = false)))
);


ALTER TABLE public.funcionarios OWNER TO henriquell;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.medicamentos (
    codigo integer NOT NULL,
    nome character varying(64) NOT NULL,
    valor numeric NOT NULL,
    receita boolean NOT NULL
);


ALTER TABLE public.medicamentos OWNER TO henriquell;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.vendas (
    id integer NOT NULL,
    funcionario character(11) NOT NULL,
    funcao_funcionario character(1) NOT NULL,
    medicamento integer NOT NULL,
    exclusivo boolean,
    id_cliente character(11),
    id_entrega integer,
    valor numeric NOT NULL,
    CONSTRAINT verifica_funcionario_chk CHECK ((funcao_funcionario = 'V'::bpchar)),
    CONSTRAINT verifica_medicamento_chk CHECK ((((id_cliente IS NOT NULL) AND (exclusivo = true)) OR (exclusivo = false)))
);


ALTER TABLE public.vendas OWNER TO henriquell;

--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: henriquell
--

CREATE SEQUENCE public.vendas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_id_seq OWNER TO henriquell;

--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: henriquell
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.entregas ALTER COLUMN id SET DEFAULT nextval('public.entregas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Data for Name: enderecos; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Name: entregas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: henriquell
--

SELECT pg_catalog.setval('public.entregas_id_seq', 1, false);


--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: henriquell
--



--
-- Name: vendas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: henriquell
--

SELECT pg_catalog.setval('public.vendas_id_seq', 1, false);


--
-- Name: clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf);


--
-- Name: entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id);


--
-- Name: farmacias_bairro_key; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_bairro_key UNIQUE (bairro);


--
-- Name: farmacias_gerente_key; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_gerente_key UNIQUE (gerente);


--
-- Name: farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id);


--
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf);


--
-- Name: medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (codigo);


--
-- Name: sede_unica_chk; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT sede_unica_chk EXCLUDE USING gist (sede_filial WITH =) WHERE ((sede_filial = 'S'::bpchar));


--
-- Name: vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- Name: enderecos_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT enderecos_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(cpf);


--
-- Name: entregas_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_funcionario_fkey FOREIGN KEY (funcionario) REFERENCES public.funcionarios(cpf);


--
-- Name: funcionarios_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_farmacia_fkey FOREIGN KEY (unidade) REFERENCES public.farmacias(id);


--
-- Name: remove_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT remove_funcionario_fkey FOREIGN KEY (funcionario) REFERENCES public.funcionarios(cpf) ON DELETE RESTRICT;


--
-- Name: remove_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT remove_medicamento_fkey FOREIGN KEY (medicamento) REFERENCES public.medicamentos(codigo) ON DELETE RESTRICT;


--
-- Name: vendas_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_funcionario_fkey FOREIGN KEY (funcionario) REFERENCES public.funcionarios(cpf);


--
-- Name: vendas_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(cpf);


--
-- Name: vendas_id_entrega_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_id_entrega_fkey FOREIGN KEY (id_entrega) REFERENCES public.entregas(id);


--
-- Name: vendas_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_medicamento_fkey FOREIGN KEY (medicamento) REFERENCES public.medicamentos(codigo);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


--
-- COMANDOS ADICIONAIS
--

-- deve ser executado com sucesso
INSERT INTO funcionarios VALUES ('98765432110', 'André Pereira', '2000-01-01', '83999999999', null, 'A', TRUE);
INSERT INTO farmacias VALUES (123, 'Catolé', 'Campina Grande', 'PB', '83912345678', 'S', 98765432110);
INSERT INTO funcionarios VALUES ('98765432111', 'Felipe Siqueira', '2000-01-10', '83988888888', 123, 'F', FALSE);
INSERT INTO funcionarios VALUES ('98765432112', 'Felipe Tata', '2000-01-30', '83988888882', 123, 'A', TRUE);
INSERT INTO farmacias VALUES (124, 'Santo Antônio', 'Parelhas', 'RN', '84988888888', 'F', 98765432112);
INSERT INTO funcionarios VALUES ('98765432113', 'Roberta Silva', '2000-01-20', '83977777777', 123, 'E', FALSE);
INSERT INTO medicamentos VALUES ( 456, 'Dorflex', 12.90, FALSE);
INSERT INTO medicamentos VALUES ( 457, 'Alivium', 12.90, TRUE);
INSERT INTO clientes VALUES ( '32323232911', 'Paty Linda', '2000-02-01', '83966666664');
INSERT INTO enderecos VALUES ('32323232911', 'trabalho', 'jkdjcsdbkdjcbdskjbdc', '1100', 'jdcnksjdc', 'sampa', 'PB', null, '12345678');
INSERT INTO enderecos VALUES ('32323232911', 'residência', 'jkdjcsdbkdjcbdskjbdc', '2300', 'jdcnksjdc', 'rio', 'RN', null, '12345678');
INSERT INTO enderecos VALUES ('32323232911', 'outro', 'jkdjcsdbkdjcbdskjbdc', '23', 'jdcnksjdc', 'rio', 'AL', null, '12345678');
INSERT INTO entregas VALUES ( DEFAULT, '98765432113', 'trabalho', '32323232911');
INSERT INTO funcionarios VALUES ('98765432114', 'Roberta Pereira', '2000-03-21', '83922222222', 123, 'V', FALSE);
INSERT INTO vendas VALUES (DEFAULT, '98765432113', 'V', 457, TRUE, '32323232911', 1, 12.90);
INSERT INTO vendas VALUES (DEFAULT, '98765432113', 'V', 456, FALSE, '32323232911', 1, 12.90);
INSERT INTO vendas VALUES (DEFAULT, '98765432113', 'V', 456, FALSE, null, null, 12.90);
INSERT INTO funcionarios VALUES ('98765432118', 'Rafael Siqueira', '2000-12-10', '83988888834', null, 'A', TRUE);


-- deve retornar erro por violar a constraint funcao_valida_chk, uma vez que só pode possuir uma função F, V, E, C ou A:
INSERT INTO funcionarios VALUES ('98765432110', 'Roberta Silva', '2000-01-20', '83977777777', null, 'Y', FALSE);

-- deve retornar erro por violar a constraint gerente_valido_chk, uma vez que só pode ser gerente sendo A ou F:
INSERT INTO funcionarios VALUES ('98765432113', 'Roberta Silva', '2000-01-20', '83977777777', 123, 'E', TRUE);

-- deve retornar erro por violar a constraint funcionarios_pkey, uma vez que um funcionário só pode estar trabalhando em uma única farmácia:
INSERT INTO funcionarios VALUES ('98765432111', 'Felipe Siqueira', '2000-01-10', '83988888888', 124, 'F', FALSE);

-- deve retornar erro por violar a unicidade de farmácias por bairro:
INSERT INTO farmacias VALUES (1235, 'Catolé', 'Campina Grande', 'PB', '83911223344', 'F', '98765432118');

-- deve retornar erro por violar a constraint sede_unica_chk, uma vez que só pode existir uma sede:
INSERT INTO farmacias VALUES (1235, 'Bodocongó', 'Campina Grande', 'PB', '83911223344', 'S', 98765432111);

-- deve retornar erro por violar a constraint sede_filial_valido_chk, uma vez que só pode ser uma sede ou uma filial:
INSERT INTO farmacias VALUES (1235, 'Bodocongó', 'Campina Grande', 'PB', 83911223344, 'L', 98765432111);

-- deve retornar erro por violar a constraint sede_filial_valido_chk, uma vez que só pode ter um gerente cadstrado por farmácia:
INSERT INTO farmacias VALUES (1235, 'Bodocongó', 'Campina Grande', 'PB', 83911223344, 'L', 98765432112);

-- deve retornar erro por violar a constraint verifica_idade, uma vez que somente pessoas maiores de 18 anos podem se cadstrar:
INSERT INTO clientes VALUES ( '32323232912', 'Marceau', '2006-02-01', '83943218765');

-- deve retornar um erro por violar a constraint verifica_categoria, uma vez que categoria só pode ser 'residência', 'trabalho' ou 'outro':
INSERT INTO enderecos VALUES ('32323232912', 'casa pedro', 'jkdjcsdbkdjcbdskjbdc', '1100', 'jdcnksjdc', 'sampa', 'RN', 'gurgaur', '12345678');

-- deve retornar um erro por causa do estado cadastrado, uma vez que só podem ser os estados da região nordeste:
henriquell_db=> INSERT INTO enderecos VALUES ('32323232911', 'residencia', 'jkdjcsdbkdjcbdskjbdc', '2300', 'jdcnksjdc', 'rio', 'SP', null, '12345678');


-- deve retornar erro, uma vez que uma entrega não pode ser realizada para pessoas não cadastradas:
INSERT INTO entregas VALUES ( DEFAULT, '98765432113', 'trabalho', null);

-- deve retornar erro por violar a constraint remove_medicamento_fkey, uma vez que só pode remover um medicamento que não esta em uma venda:
DELETE FROM medicamentos WHERE codigo = 456;

-- deve retornar erro por violar a constraint remove_funcionario_fkey, uma vez que só pode remover um funcionário que não esta em uma venda:
DELETE FROM funcionarios WHERE cpf = '83922222222';

-- deve retornar erro por violar a constraint verifica_funcionario_chk, uma vez que somente um vendedor pode realizar uma venda:
INSERT INTO vendas VALUES (DEFAULT, '98765432110', 'A', 457, FALSE, null, null, 12.90);
