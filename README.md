<img width="150" alt="Camada 1" src="https://github.com/user-attachments/assets/d8888f64-03ce-4cbe-823a-9e259c96b011" />


# Gestão e venda de raspadinhas

Esta documentação descreve a API RESTful para o ciclo de vida das raspadinhas, abrangendo desde a criação e configuração de premiação até a distribuição, venda e resgate de prêmios.

Esta documentação será dividida em duas seções principais:

- Gestão de raspadinhas: Abrange os endpoints relacionados à configuração, criação e gerenciamento dos lotes, incluindo a definição de prêmios, distribuição e outros recursos administrativos.

- Vendas e operações: Detalha os endpoints para a interação do usuário com as raspadinhas, como compra, revelação de prêmios e solicitação de resgate.

# Endpoints (URLs)

> [!TIP]
> Observe que estes são apenas os caminhos das URLs; os métodos HTTP (GET, POST, PUT, DELETE) e os parâmetros de requisição e resposta serão detalhados posteriormente.

### Seção 1: Gestão de raspadinhas

1.1 LOTES DE RASPADINHAS

	Criar lote de raspadinha: /api/v1/raspadinhas/lotes 
 
	Obter lote de raspadinha ID: /api/v1/raspadinhas/lotes/{lote_id}
 
	Listar lotes de raspadinha: /api/v1/raspadinhas/lotes
 
	Atualizar lote de raspadinha: /api/v1/raspadinhas/lotes/{lote_id}
 
	Deletar lote de raspadinha: /api/v1/raspadinhas/lotes/{lote_id}
 


1.2 CONFIGURAÇÃO DE PREMIAÇÃO

	Definir configurações de premiação por lote: /api/v1/raspadinhas/lotes/{lote_id}/premiacao
 
	Obter configurações de premiação por lote: /api/v1/raspadinhas/lotes/{lote_id}/premiacao
 
	Atualizar configurações de premiação por lote: /api/v1/raspadinhas/lotes/{lote_id}/premiacao
 


1.3 DISTRIBUIÇÃO DE PREMIOS

	Distribuir prêmios em lote: /api/v1/raspadinhas/lotes/{lote_id}/distribuicao-premios
 
	Obter status de distribuição de prêmios: /api/v1/raspadinhas/lotes/{lote_id}/distribuicao-premios/status


 
 1.4 RASPADINHAS INDIVIDUAIS (dentro de um lote)

	Listar raspadinhas em lote: /api/v1/raspadinhas/lotes/{lote_id}/raspadinhas
 
	Obter raspadinha por ID (dentro de Lote): /api/v1/raspadinhas/lotes/{lote_id}/raspadinhas/{raspadinha_id}
 
	Atualizar status de raspadinha (e.g., Ativa/Inativa): /api/v1/raspadinhas/lotes/{lote_id}/raspadinhas/{raspadinha_id}/status


### Seção 2: Vendas e operações

2.1 COMPRA DE RASPADINHAS

	Comprar raspadinha: /api/v1/vendas/comprar
 
	Listar raspadinhas compradas pelo usuário: /api/v1/usuarios/{user_id}/raspadinhas-compradas


2.2 REVELAÇÃO DE PRÊMIO

	Revelar prêmio de raspadinha: /api/v1/vendas/revelar/{raspadinha_id}


2.3 SOLICITAÇÃO DE PRÊMIO

	Solicitar resgate de prêmio: /api/v1/vendas/solicitar-premio/{raspadinha_id}
 
	Listar solicitações de prêmios (para admin): /api/v1/admin/solicitacoes-premios
 
	Atualizar status de solicitação de prêmio (para admin): /api/v1/admin/solicitacoes-premios/{solicitacao_id}/status


