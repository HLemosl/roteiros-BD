-- Comentários:
-- Questão 1: Desenvolvimento da relação de tarefas. A solução de seus erros foram desenvolvidos apenas pela análise da inserção do valores.

-- Questão 2: 
	-- Comando 2: Para que a inserção fosse realizada, foi necessário trocar o tipo do atributo 'identificador' para entrar valores maiores que o tipo integer não permite.
-- Questão 3: Para a solução deste problema foi necessário alterar o tipo do atributo 'prioridade' para smallint.

-- Questão 4: Para resolver estão questão foi necessário implementar um 'delete' na relação de 'tarefas', onde os valores são NULL.

-- Questão 5: Situação resolvida com a definição de uma PK no atributo de 'id' da relação 'tarefas', pois assim não permitiria a inserção de dois valores com o mesmo identificador.

-- Questão 6: Na parte 'A', a partir da definição de uma constraint, usamos para verificar se o atributo 'func_resp_cpf' possui exatamente 11 caractéres. Já na parte 'B', foi realizado uma atualização nos valores, alterando os valores 'A', 'R' e 'F', pelos valores permitidos; antes de criar a verificação desejada.

-- Questão 7: Para a solução desta questão foi realizado uma verificação, onde os valores de prioridade estivesse dentro do limite permitido.

-- Questão 8: Criação da relação 'funcionario'.

-- Questão 9: Criação de testes que verifica se os casos específicados e as constraints estão definidas corretamente.

-- Questão 10: Para a solução do erro, foram inseridos os funcionários, em que suas tarefas estavam cadastradas na relação 'tarefas', na relação 'funcionário', antes de definir as constraints. O erro encontrado na opção 2 foi:
--
--		DELETE FROM funcionario WHERE cpf = '32323232955';
--		ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"
--		DETAIL:  Key (cpf)=(32323232955) is still referenced from table "tarefas".

-- Questão 11: Foi realizado a criação das constraints desejadas. A exibição dos erros nos testes de remoção das tuplas que tinham seus valores de status 'C' e 'E', foram:
--
--		ERROR:  new row for relation "tarefas" violates check constraint "tarefas_func_resp_cpf_chk_valido"
--		DETAIL:  Failing row contains (2147483647, limpar janelas da sala 203, null, 1, C).
--		CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""
--
--		ERROR:  new row for relation "tarefas" violates check constraint "tarefas_func_resp_cpf_chk_valido"
--		DETAIL:  Failing row contains (2147483645, limpar portas do 3o andar, null, 1, E).
--		CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(80) NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcao_valido_chk CHECK (((((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT niveil_valido_chk CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar)))
);


ALTER TABLE public.funcionario OWNER TO henriquell;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: henriquell
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao character varying(60) NOT NULL,
    func_resp_cpf character(11),
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT func_chk_numcpf_valido CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT prioridade_chk_valido CHECK (((prioridade > '-1'::integer) AND (prioridade < 6))),
    CONSTRAINT status_chk_valido CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar))),
    CONSTRAINT tarefas_func_resp_cpf_chk_valido CHECK ((((status = 'C'::bpchar) AND (func_resp_cpf IS NOT NULL)) OR ((status = 'E'::bpchar) AND (func_resp_cpf IS NOT NULL)) OR (status = 'P'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO henriquell;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: henriquell
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1980-08-10', 'Eliane Prestes', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1980-08-20', 'Mirandra Sintra', 'LIMPEZA', 'S', '12345678914');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1980-08-30', 'Maryam Festas', 'SUP_LIMPEZA', 'J', '12345678914');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1980-09-01', 'Delmar Bezerril', 'LIMPEZA', 'P', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1980-09-10', 'Emilia Lisboa', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1980-09-20', 'Andria Gois', 'LIMPEZA', 'J', '12345678918');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920', '1980-09-30', 'Sebastian Camargo', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '1980-10-10', 'Kataleya Pontes', 'SUP_LIMPEZA', 'J', '12345678920');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1980-10-20', 'Maryam Anjos', 'LIMPEZA', 'J', '12345678920');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1980-10-30', 'Viktoriya Liberato', 'LIMPEZA', 'P', '12345678920');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1980-10-01', 'Danilo Viana', 'LIMPEZA', 'S', '12345678920');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: henriquell
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483645, 'limpar portas do 3o andar', '12345678921', 1, 'E');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', NULL, 4, 'P');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: henriquell
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

