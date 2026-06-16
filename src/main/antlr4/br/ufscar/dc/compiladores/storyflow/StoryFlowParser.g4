parser grammar StoryFlowParser;

options { tokenVocab = StoryFlowLexer; }

// =========================================================================
// REGRA INICIAL
// Um programa é um bloco opcional de itens globais seguido de uma ou mais cenas
// =========================================================================
programa : itens_globais? cena+ EOF ;

// =========================================================================
// ITENS GLOBAIS
// Declara os itens (variáveis de estado) que existem no universo do jogo
// =========================================================================
itens_globais : ITENS_GLOBAIS DOIS_PONTOS itens+=STRING (VIRGULA itens+=STRING)* ;

// =========================================================================
// CENA
// Bloco narrativo identificado por nome único. A cena com 'inicio' é o ponto de entrada
// =========================================================================
cena : CENA nome=STRING INICIO? DOIS_PONTOS instrucao* ;

// =========================================================================
// INSTRUÇÃO
// As três construções possíveis dentro de uma cena
// =========================================================================
instrucao : narracao
          | escolha
          | condicional
          ;

// Narração: exibe texto ao jogador
narracao : NARRACAO texto=STRING ;

// Escolha: cria um botão que pode pegar um item opcionalmente e navega para outra cena
escolha : ESCOLHA textoEscolha=STRING (PEGAR_ITEM nomeItem=STRING)? VAI_PARA nomeCena=STRING ;

// Condicional: ramifica o fluxo com base no inventário do jogador
// Os labels 'entao' e 'senao' separam as instruções dos dois ramos
condicional : SE TEM_ITEM nomeItemCond=STRING ENTAO DOIS_PONTOS
              entao+=instrucao*
              (SENAO DOIS_PONTOS senao+=instrucao*)?
              FIM_SE ;
