
DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS solicitacoes_premios;
DROP TABLE IF EXISTS raspadinhas;
DROP TABLE IF EXISTS configuracoes_premiacao;
DROP TABLE IF EXISTS lotes_raspadinhas;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE IF NOT EXISTS usuarios (
    id VARCHAR(36) PRIMARY KEY, -- UUIDs como VARCHAR(36)
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL, 
    tipo_usuario VARCHAR(50) NOT NULL DEFAULT 'jogador', -- 'jogador' ou 'admin'
    saldo DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS lotes_raspadinhas (
    id VARCHAR(36) PRIMARY KEY,  -- UUIDs como VARCHAR(36)
    nome_lote VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco_raspadinha DECIMAL(10, 2) NOT NULL,
    quantidade_total_raspadinhas INT NOT NULL,
    quantidade_disponivel INT NOT NULL,
    valor_total_premios DECIMAL(10, 2) NOT NULL,
    percentual_rtp DECIMAL(5, 2) NOT NULL, -- Return to player (ex 85.00 para 85%)
    status VARCHAR(50) NOT NULL DEFAULT 'ativo', -- 'ativo', 'inativo', 'esgotado', 'concluido'
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_inicio_vendas TIMESTAMP NULL, -- Pode ser NULL se ainda não começou a vender
    data_fim_vendas TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS configuracoes_premiacao (
    id VARCHAR(36) PRIMARY KEY, -- UUIDs como VARCHAR(36)
    lote_id VARCHAR(36) NOT NULL,
    nome_premio VARCHAR(255) NOT NULL,
    valor_premio DECIMAL(10, 2) NOT NULL,
    quantidade_premios INT NOT NULL,
    FOREIGN KEY (lote_id) REFERENCES lotes_raspadinhas(id) ON DELETE CASCADE,
    UNIQUE (lote_id, nome_premio) -- Garante que não haja prêmios duplicados para o mesmo lote
);

CREATE TABLE IF NOT EXISTS raspadinhas (
    id VARCHAR(36) PRIMARY KEY, -- UUIDs como VARCHAR(36)
    lote_id VARCHAR(36) NOT NULL,
    codigo_unico VARCHAR(255) UNIQUE NOT NULL, -- Código único para cada raspadinha (pode ser gerado internamente)
    valor_premio_oculto DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- 0.00 para não premiada
    status VARCHAR(50) NOT NULL DEFAULT 'disponivel', -- 'disponivel', 'vendida', 'raspada', 'premiada', 'resgatado'
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_venda TIMESTAMP NULL,
    data_raspada TIMESTAMP NULL,
    data_resgate_premio TIMESTAMP NULL,
    comprador_id VARCHAR(36) NULL, -- NULL se não vendida
    FOREIGN KEY (lote_id) REFERENCES lotes_raspadinhas(id) ON DELETE CASCADE,
    FOREIGN KEY (comprador_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS solicitacoes_premios (
    id VARCHAR(36) PRIMARY KEY, --- UUIDs como VARCHAR(36)
    raspadinha_id VARCHAR(36) UNIQUE NOT NULL, -- Cada raspadinha só pode ter uma solicitação de prêmio
    usuario_id VARCHAR(36) NOT NULL,
    valor_premio DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pendente', -- 'pendente', 'aprovado', 'rejeitado', 'pago'
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    observacoes TEXT,
    FOREIGN KEY (raspadinha_id) REFERENCES raspadinhas(id) ON DELETE RESTRICT, -- Não permitir deletar raspadinha com solicitação pendente
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS transacoes (
    id VARCHAR(36) PRIMARY KEY, -- UUIDs como VARCHAR(36)
    usuario_id VARCHAR(36) NOT NULL,
    tipo_transacao VARCHAR(50) NOT NULL, -- 'compra_raspadinha', 'deposito', 'saque_premio', 'ajuste_saldo'
    valor DECIMAL(10, 2) NOT NULL,
    raspadinha_id VARCHAR(36) NULL, -- Opcional, para transações de compra/resgate de raspadinha
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'concluido', -- 'pendente', 'concluido', 'falhou'
    descricao TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (raspadinha_id) REFERENCES raspadinhas(id) ON DELETE SET NULL
);

---

-- Inserção de dados exemplo

---

INSERT INTO usuarios (id, nome, email, senha_hash, tipo_usuario, saldo) VALUES
(UUID(), 'Alice Silva', 'alice.silva@example.com', 'hash_alice_123', 'jogador', 150.00);
SET @alice_id = (SELECT id FROM usuarios WHERE email = 'alice.silva@example.com');

INSERT INTO usuarios (id, nome, email, senha_hash, tipo_usuario, saldo) VALUES
(UUID(), 'Bruno Santos', 'bruno.santos@example.com', 'hash_bruno_456', 'jogador', 50.00);
SET @bruno_id = (SELECT id FROM usuarios WHERE email = 'bruno.santos@example.com');

INSERT INTO usuarios (id, nome, email, senha_hash, tipo_usuario, saldo) VALUES
(UUID(), 'Carlos Administrador', 'carlos.admin@example.com', 'hash_carlos_789', 'admin', 0.00);
SET @carlos_id = (SELECT id FROM usuarios WHERE email = 'carlos.admin@example.com');

INSERT INTO usuarios (id, nome, email, senha_hash, tipo_usuario, saldo) VALUES
(UUID(), 'Diana Costa', 'diana.costa@example.com', 'hash_diana_012', 'jogador', 200.00);
SET @diana_id = (SELECT id FROM usuarios WHERE email = 'diana.costa@example.com');


INSERT INTO lotes_raspadinhas (id, nome_lote, descricao, preco_raspadinha, quantidade_total_raspadinhas, quantidade_disponivel, valor_total_premios, percentual_rtp, status, data_inicio_vendas, data_fim_vendas) VALUES
(UUID(), 'Verão Premiado 2025', 'Raspadinhas com tema de verão e prêmios refrescantes!', 5.00, 1000, 995, 4000.00, 80.00, 'ativo', '2025-05-20 09:00:00', '2025-08-31 23:59:59');
SET @lote_verao_id = (SELECT id FROM lotes_raspadinhas WHERE nome_lote = 'Verão Premiado 2025');

INSERT INTO lotes_raspadinhas (id, nome_lote, descricao, preco_raspadinha, quantidade_total_raspadinhas, quantidade_disponivel, valor_total_premios, percentual_rtp, status, data_inicio_vendas, data_fim_vendas) VALUES
(UUID(), 'Natal Mágico 2025', 'Prêmios especiais para o Natal!', 10.00, 500, 500, 3750.00, 75.00, 'ativo', '2025-11-01 09:00:00', '2025-12-25 23:59:59');
SET @lote_natal_id = (SELECT id FROM lotes_raspadinhas WHERE nome_lote = 'Natal Mágico 2025');


INSERT INTO configuracoes_premiacao (id, lote_id, nome_premio, valor_premio, quantidade_premios) VALUES
(UUID(), @lote_verao_id, 'Prêmio Principal', 1000.00, 1),
(UUID(), @lote_verao_id, 'Prêmio Secundário', 100.00, 5),
(UUID(), @lote_verao_id, 'Prêmio Básico', 5.00, 400);

INSERT INTO configuracoes_premiacao (id, lote_id, nome_premio, valor_premio, quantidade_premios) VALUES
(UUID(), @lote_natal_id, 'Super Prêmio Natal', 500.00, 2),
(UUID(), @lote_natal_id, 'Presente Natalino', 50.00, 10),
(UUID(), @lote_natal_id, 'Brinde', 10.00, 250);



INSERT INTO raspadinhas (id, lote_id, codigo_unico, valor_premio_oculto, status) VALUES
(UUID(), @lote_verao_id, 'RASP-VERAO-001', 1000.00, 'disponivel'), -- Prêmio Principal
(UUID(), @lote_verao_id, 'RASP-VERAO-002', 100.00, 'disponivel'),
(UUID(), @lote_verao_id, 'RASP-VERAO-003', 5.00, 'disponivel'),
(UUID(), @lote_verao_id, 'RASP-VERAO-004', 0.00, 'disponivel'),
(UUID(), @lote_verao_id, 'RASP-VERAO-005', 0.00, 'disponivel');

-- Simular uma raspadinha comprada e raspada
INSERT INTO raspadinhas (id, lote_id, codigo_unico, valor_premio_oculto, status, data_venda, data_raspada, comprador_id) VALUES
(UUID(), @lote_verao_id, 'RASP-VERAO-006', 5.00, 'premiada', NOW() - INTERVAL 1 HOUR, NOW() - INTERVAL 30 MINUTE, @alice_id);
SET @raspadinha_vendida_premiada_id = (SELECT id FROM raspadinhas WHERE codigo_unico = 'RASP-VERAO-006');

-- Simular uma raspadinha comprada e não raspada
INSERT INTO raspadinhas (id, lote_id, codigo_unico, valor_premio_oculto, status, data_venda, comprador_id) VALUES
(UUID(), @lote_verao_id, 'RASP-VERAO-007', 0.00, 'vendida', NOW() - INTERVAL 2 HOUR, @bruno_id);
SET @raspadinha_vendida_nao_raspada_id = (SELECT id FROM raspadinhas WHERE codigo_unico = 'RASP-VERAO-007');


INSERT INTO solicitacoes_premios (id, raspadinha_id, usuario_id, valor_premio, status) VALUES
(UUID(), @raspadinha_vendida_premiada_id, @alice_id, 5.00, 'pendente');


INSERT INTO transacoes (id, usuario_id, tipo_transacao, valor, raspadinha_id, status, descricao) VALUES
(UUID(), @alice_id, 'compra_raspadinha', 5.00, @raspadinha_vendida_premiada_id, 'concluido', 'Compra Raspadinha Verão Premiado'),
(UUID(), @bruno_id, 'compra_raspadinha', 5.00, @raspadinha_vendida_nao_raspada_id, 'concluido', 'Compra Raspadinha Verão Premiado'),
(UUID(), @alice_id, 'deposito', 50.00, NULL, 'concluido', 'Depósito via Pix');
