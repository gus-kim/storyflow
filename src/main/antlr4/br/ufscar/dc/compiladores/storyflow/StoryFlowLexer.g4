lexer grammar StoryFlowLexer;

// =========================================================================
// PALAVRAS-CHAVE
// =========================================================================
ITENS_GLOBAIS : 'itens_globais' ;
CENA          : 'cena' ;
INICIO        : 'inicio' ;
NARRACAO      : 'narracao' ;
ESCOLHA       : 'escolha' ;
PEGAR_ITEM    : 'pegar_item' ;
VAI_PARA      : 'vai_para' ;
SE            : 'se' ;
TEM_ITEM      : 'tem_item' ;
ENTAO         : 'entao' ;
SENAO         : 'senao' ;
FIM_SE        : 'fim_se' ;

// =========================================================================
// PONTUAÇÃO
// =========================================================================
DOIS_PONTOS : ':' ;
VIRGULA     : ',' ;

// =========================================================================
// LITERAL DE TEXTO
// Aceita qualquer caractere entre aspas duplas, exceto quebra de linha
// =========================================================================
STRING : '"' (~["\r\n])* '"' ;

// =========================================================================
// IGNORADOS
// =========================================================================
COMENTARIO : '//' ~[\r\n]* -> skip ;
WS         : [ \t\r\n]+   -> skip ;
