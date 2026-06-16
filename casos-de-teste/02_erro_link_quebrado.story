// Caso de teste 2 — DEVE FALHAR: link quebrado
// Regra semântica 3: vai_para aponta para cena "Sala Secreta" que não foi declarada

itens_globais:
    "Chave"

cena "Inicio" inicio:
    narracao "Uma sala comum."
    escolha "Tentar entrar na sala secreta" vai_para "Sala Secreta"
    escolha "Ficar aqui" vai_para "Inicio"

// Erro esperado:
// Erro semântico [linha X]: link quebrado — a cena "Sala Secreta" não existe.
