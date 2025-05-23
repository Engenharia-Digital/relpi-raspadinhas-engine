# Engenharia Digital - Gestão e venda de raspadinhas

Esta documentação descreve a API RESTful para o ciclo de vida das raspadinhas, abrangendo desde a criação e configuração de premiação até a distribuição, venda e resgate de prêmios.

Esta documentação será dividida em duas seções principais:

⚙️ Gestão de raspadinhas: Abrange os endpoints relacionados à configuração, criação e gerenciamento dos lotes, incluindo a definição de prêmios, distribuição e outros recursos administrativos.

⚙️ Vendas e operações: Detalha os endpoints para a interação do usuário com as raspadinhas, como compra, revelação de prêmios e solicitação de resgate.

# Endpoints (URLs)

_Observe que estes são apenas os caminhos das URLs; os métodos HTTP (GET, POST, PUT, DELETE) e os parâmetros de requisição e resposta serão detalhados posteriormente._

1.1 LOTES DE RASPADINHAS

	Criar lote de raspadinha: /api/v1/raspadinhas/lotes 	
	Obter lote de raspadinha ID: /api/v1/raspadinhas/lotes/{lote_id}
	Listar lote de raspadinha: /api/v1/raspadinhas/lotes
	Atualizar lote de raspadinha: /api/v1/raspadinhas/lotes/{lote_id}
	Deletar lote de raspadinha: /api/v1/raspadinhas/lotes/{lote_id}
