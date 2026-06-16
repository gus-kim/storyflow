// Caso de teste 4 — DEVE FALHAR: cena duplicada
// Regra semântica 1: a cena "Sala" aparece declarada duas vezes

itens_globais:
    "Item"

cena "Sala" inicio:
    narracao "Primeira declaração da sala."
    escolha "Ir à outra sala" vai_para "Outro Lugar"

cena "Sala":
    narracao "Segunda declaração — isso é um erro!"
    escolha "Voltar" vai_para "Sala"

cena "Outro Lugar":
    narracao "Um lugar diferente."
    escolha "Voltar" vai_para "Sala"

// Erro esperado:
// Erro semântico: cena "Sala" declarada 2 vezes.
