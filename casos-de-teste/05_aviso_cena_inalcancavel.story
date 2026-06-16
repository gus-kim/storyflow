// Caso de teste 5 — COMPILA COM AVISO: cena inalcançável
// Regra semântica 5: a cena "Sala Escondida" existe mas nenhuma escolha aponta para ela

itens_globais:
    "Mapa"

cena "Inicio" inicio:
    narracao "Você está no ponto de partida."
    escolha "Ir para o fim" vai_para "Fim"

cena "Fim":
    narracao "Você chegou ao fim da jornada."

cena "Sala Escondida":
    narracao "Esta cena nunca será alcançada pelo jogador."
    escolha "Voltar" vai_para "Inicio"

// Aviso esperado (não bloqueia compilação):
// Aviso: a cena "Sala Escondida" é inalcançável (nenhuma escolha aponta para ela).
