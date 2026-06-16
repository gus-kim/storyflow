// Caso de teste 3 — DEVE FALHAR: item fantasma
// Regra semântica 4: "Poção Mágica" usada em tem_item mas não declarada em itens_globais

itens_globais:
    "Chave"

cena "Inicio" inicio:
    narracao "Você está num corredor."
    se tem_item "Poção Mágica" entao:
        escolha "Usar a poção" vai_para "Fim"
    senao:
        escolha "Continuar sem poção" vai_para "Fim"
    fim_se

cena "Fim":
    narracao "Chegou ao fim."

// Erro esperado:
// Erro semântico [linha X]: item fantasma — "Poção Mágica" não declarado em itens_globais.
