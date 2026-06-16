// Caso de teste 1 — história completa sem erros
// Demonstra: itens_globais, cenas, narracao, escolha, pegar_item, se/senao/fim_se

itens_globais:
    "Tocha", "Espada Lendária"

cena "Entrada da Caverna" inicio:
    narracao "Você está na entrada de uma caverna escura e misteriosa."
    narracao "Dois caminhos se abrem à sua frente."
    escolha "Seguir pelo caminho da esquerda" vai_para "Sala Escura"
    escolha "Seguir pelo caminho da direita" vai_para "Sala Iluminada"

cena "Sala Escura":
    narracao "Está completamente escuro. Você mal consegue ver a própria mão."
    se tem_item "Tocha" entao:
        narracao "Mas a sua tocha ilumina o caminho à frente!"
        escolha "Avançar corajosamente" vai_para "Tesouro"
    senao:
        narracao "Sem luz, avançar seria suicida."
        escolha "Recuar e tentar a outra passagem" vai_para "Sala Iluminada"
    fim_se

cena "Sala Iluminada":
    narracao "Esta sala tem um cristal brilhante no teto que ilumina tudo."
    narracao "Você vê uma tocha pendurada na parede."
    escolha "Pegar a tocha e explorar a escuridão" pegar_item "Tocha" vai_para "Sala Escura"
    escolha "Ignorar a tocha e voltar" vai_para "Entrada da Caverna"

cena "Tesouro":
    narracao "No centro da câmara repousa um baú antigo coberto de poeira."
    narracao "Dentro dele, uma espada reluz com uma luz própria."
    escolha "Pegar a Espada Lendária" pegar_item "Espada Lendária" vai_para "Vitória"
    escolha "Deixar o tesouro e sair" vai_para "Entrada da Caverna"

cena "Vitória":
    narracao "Com a Espada Lendária em mãos, você sente um poder imenso."
    narracao "Você se torna o herói lendário que todos esperavam."
    narracao "[ FIM ]"
