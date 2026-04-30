-- Sistema de Gestão de Oficina Mecânica de Bicicletas
-- Baseado no TCC de Leandro de Carvalho Rodrigues - UNESA 2018

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS usuario (
    idusuario INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario VARCHAR(10) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    funcao VARCHAR(20) NOT NULL,
    tipofuncao INTEGER NOT NULL CHECK(tipofuncao IN (1,2,3)),
    -- 1=Gerente, 2=Vendedor, 3=Mecânico
    ativo INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS cliente (
    idcliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    endereco VARCHAR(100),
    telefone VARCHAR(15),
    email VARCHAR(60),
    ativo INTEGER NOT NULL DEFAULT 1,
    datacadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bicicleta (
    idbicicleta INTEGER PRIMARY KEY AUTOINCREMENT,
    idcliente INTEGER NOT NULL,
    marca VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    cor VARCHAR(10),
    ano INTEGER,
    numero_serie VARCHAR(30),
    ativo INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY(idcliente) REFERENCES cliente(idcliente)
);

CREATE TABLE IF NOT EXISTS fornecedor (
    idfornecedor INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(60) NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    email VARCHAR(40),
    contato VARCHAR(30),
    endereco VARCHAR(100),
    ativo INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS produto (
    idproduto INTEGER PRIMARY KEY AUTOINCREMENT,
    idfornecedor INTEGER NOT NULL,
    descricao VARCHAR(60) NOT NULL,
    valor NUMERIC(10,2) NOT NULL DEFAULT 0,
    ativo INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY(idfornecedor) REFERENCES fornecedor(idfornecedor)
);

CREATE TABLE IF NOT EXISTS estoque (
    idestoque INTEGER PRIMARY KEY AUTOINCREMENT,
    idproduto INTEGER NOT NULL UNIQUE,
    estoqueini INTEGER NOT NULL DEFAULT 0,
    estoqueatual INTEGER NOT NULL DEFAULT 0,
    dataalt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(idproduto) REFERENCES produto(idproduto)
);

CREATE TABLE IF NOT EXISTS pedido (
    idpedido INTEGER PRIMARY KEY AUTOINCREMENT,
    idcliente INTEGER NOT NULL,
    idusuario INTEGER NOT NULL,
    total NUMERIC(10,2) DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'ABERTO' CHECK(status IN ('ABERTO','CONCLUIDO','CANCELADO')),
    observacao TEXT,
    datacriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(idcliente) REFERENCES cliente(idcliente),
    FOREIGN KEY(idusuario) REFERENCES usuario(idusuario)
);

CREATE TABLE IF NOT EXISTS itempedido (
    iditempedido INTEGER PRIMARY KEY AUTOINCREMENT,
    idpedido INTEGER NOT NULL,
    idproduto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1,
    valorunitario NUMERIC(10,2) NOT NULL,
    FOREIGN KEY(idpedido) REFERENCES pedido(idpedido),
    FOREIGN KEY(idproduto) REFERENCES produto(idproduto)
);

CREATE TABLE IF NOT EXISTS tiposervico (
    idtiposervico INTEGER PRIMARY KEY AUTOINCREMENT,
    tiposervico VARCHAR(60) NOT NULL,
    valor NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ordemservico (
    idordem INTEGER PRIMARY KEY AUTOINCREMENT,
    idcliente INTEGER NOT NULL,
    idbicicleta INTEGER NOT NULL,
    idusuario INTEGER NOT NULL,
    idtiposervico INTEGER,
    descricao TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ABERTA' CHECK(status IN ('ABERTA','EM_ANDAMENTO','CONCLUIDA','CANCELADA')),
    justificativa_cancelamento TEXT,
    valortotal NUMERIC(10,2) DEFAULT 0,
    datacriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    dataconclusao DATETIME,
    FOREIGN KEY(idcliente) REFERENCES cliente(idcliente),
    FOREIGN KEY(idbicicleta) REFERENCES bicicleta(idbicicleta),
    FOREIGN KEY(idusuario) REFERENCES usuario(idusuario),
    FOREIGN KEY(idtiposervico) REFERENCES tiposervico(idtiposervico)
);

CREATE TABLE IF NOT EXISTS itemordem (
    iditemordem INTEGER PRIMARY KEY AUTOINCREMENT,
    idordem INTEGER NOT NULL,
    idproduto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1,
    valorunitario NUMERIC(10,2) NOT NULL,
    FOREIGN KEY(idordem) REFERENCES ordemservico(idordem),
    FOREIGN KEY(idproduto) REFERENCES produto(idproduto)
);

-- Dados iniciais
INSERT OR IGNORE INTO usuario (usuario, senha, nome, cpf, funcao, tipofuncao) 
VALUES ('admin', '$2b$10$YKxGqxJ8vGmTyzNB.gqzx.6D5kJO6nBT1YE3F5VUXQWbH3eElEZim', 'Administrador', '00000000000', 'Gerente', 1);
-- senha padrão: admin123

INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Revisão Básica', 80.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Revisão Completa', 150.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Troca de Câmara', 30.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Troca de Pneu', 50.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Ajuste de Freio', 40.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Ajuste de Câmbio', 40.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Manutenção Preventiva', 120.00);
INSERT OR IGNORE INTO tiposervico (tiposervico, valor) VALUES ('Bike Fitting', 200.00);
