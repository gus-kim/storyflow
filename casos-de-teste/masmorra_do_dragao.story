// A Masmorra do Dragão Escarlate
// Uma aventura de fantasia com múltiplos caminhos e finais

itens_globais:
    "Tocha", "Escudo Mágico", "Pergaminho Antigo", "Nome Proibido"

// ─────────────────────────────────────────────
// INTRODUÇÃO
// ─────────────────────────────────────────────

cena "Menu Principal" inicio:
    narracao "A MASMORRA DO DRAGÃO ESCARLATE"
    narracao "Uma aventura de fantasia com múltiplos caminhos e finais."
    narracao "Suas escolhas determinam o destino do reino."
    escolha "Iniciar Aventura" vai_para "Portão da Masmorra"
    escolha "Sair" vai_para "Tela de Saída"

cena "Tela de Saída":
    narracao "Obrigado por jogar A Masmorra do Dragão Escarlate."
    narracao "Para sair, feche esta aba no seu navegador."
    escolha "Voltar ao Menu" vai_para "Menu Principal"

cena "Portão da Masmorra":
    narracao "O portão de pedra negra se abre diante de você com um rangido sinistro."
    narracao "Uma brisa gelada escapa de dentro, carregando o cheiro de enxofre e cinzas."
    narracao "Há décadas o Dragão Escarlate habita estas profundezas, cobrando tributos de sangue do reino."
    narracao "Você é o único aventureiro corajoso — ou louco — o suficiente para tentar acabar com isso."
    narracao "Você verifica o equipamento: espada no cinturão, armadura leve nas costas. Pronto para o que vier."
    narracao "Na parede da entrada, uma tocha ainda queima. Alguém esteve aqui antes de você."
    se tem_item "Tocha" entao:
        escolha "Entrar na masmorra" vai_para "Corredor de Entrada"
    senao:
        escolha "Pegar a tocha e entrar" pegar_item "Tocha" vai_para "Corredor de Entrada"
        escolha "Entrar sem a tocha, rápido e silencioso" vai_para "Corredor de Entrada"
    fim_se

// ─────────────────────────────────────────────
// CORREDOR DE ENTRADA
// ─────────────────────────────────────────────

cena "Corredor de Entrada":
    narracao "O corredor desce em espiral, as paredes marcadas por garras imensas."
    narracao "Você passa por armaduras de guerreiros anteriores, enferrujadas e vazias."
    se tem_item "Tocha" entao:
        narracao "Sua tocha ilumina inscrições antigas no chão: 'O fogo teme o Antigo Nome. O aço resiste ao fogo.'"
        narracao "As inscrições apontam para dois corredores: norte e leste."
        escolha "Seguir pelo corredor norte" vai_para "Cruzamento"
    senao:
        narracao "No escuro, você mal consegue ver os corredores que se abrem à sua frente."
        narracao "Você sente que precisaria de luz para explorar com segurança."
        escolha "Voltar e pegar a tocha na entrada" vai_para "Portão da Masmorra"
        escolha "Continuar no escuro mesmo assim" vai_para "Morte no Corredor"
    fim_se

// ─────────────────────────────────────────────
// CRUZAMENTO — HUB CENTRAL
// ─────────────────────────────────────────────

cena "Cruzamento":
    narracao "Você chega a uma câmara circular, pé-direito alto, com três portas de ferro."
    narracao "Uma ao norte com o símbolo de um livro. Uma a leste com o símbolo de uma espada. Uma ao sul — selada com correntes grossas."
    se tem_item "Pergaminho Antigo" entao:
        narracao "O Pergaminho Antigo repousa seguro na sua bolsa. Você sabe o segredo do dragão."
    senao:
        escolha "Entrar pela porta norte — Biblioteca Sombria" vai_para "Biblioteca Sombria"
    fim_se
    se tem_item "Escudo Mágico" entao:
        narracao "O Escudo Mágico pulsa com uma luz suave em seu braço."
    senao:
        escolha "Entrar pela porta leste — Câmara das Armas" vai_para "Câmara das Armas"
    fim_se
    escolha "Arrombar as correntes e enfrentar o dragão" vai_para "Covil do Dragão"

// ─────────────────────────────────────────────
// BIBLIOTECA SOMBRIA
// ─────────────────────────────────────────────

cena "Biblioteca Sombria":
    narracao "Prateleiras que chegam ao teto, cobertas por livros que nenhum humano deveria ler."
    narracao "No centro da sala, sobre uma mesa de pedra, um pergaminho está aberto como se alguém o deixou assim de propósito."
    se tem_item "Tocha" entao:
        narracao "À luz da sua tocha, você lê: 'O Dragão Escarlate tem uma fraqueza conhecida apenas pelos Magos Antigos.'"
        narracao "'Pronuncie o Nome Proibido — Karath sul — e ele hesitará por um instante. Um instante é tudo que você precisará.'"
        narracao "Você copia o nome na palma da mão com carvão da tocha."
        escolha "Pegar o Pergaminho Antigo e guardar para consulta" pegar_item "Pergaminho Antigo" vai_para "Cruzamento"
        escolha "Memorizar o nome e deixar o pergaminho" pegar_item "Nome Proibido" vai_para "Cruzamento"
    senao:
        narracao "Está escuro demais para ler qualquer coisa. As letras se perdem nas sombras."
        narracao "Você precisaria de luz para decifrar o que está escrito."
        escolha "Voltar ao cruzamento" vai_para "Cruzamento"
    fim_se

// ─────────────────────────────────────────────
// CÂMARA DAS ARMAS
// ─────────────────────────────────────────────

cena "Câmara das Armas":
    narracao "A câmara cheira a metal e sangue seco. Armas quebradas cobrem o chão."
    narracao "Na parede do fundo, um escudo diferente de todos os outros. Não enferrujado. Não partido."
    narracao "Gravado nele, um dragão dobrado sobre si mesmo — devorando a própria cauda."
    narracao "Ao lado, uma placa: 'Forjado com escamas do Primeiro Dragão. Resiste ao fogo eterno.'"
    escolha "Pegar o Escudo Mágico" pegar_item "Escudo Mágico" vai_para "Cruzamento"
    escolha "Deixar o escudo — você não precisa de proteção" vai_para "Cruzamento"

// ─────────────────────────────────────────────
// COVIL DO DRAGÃO — CONFRONTO FINAL
// ─────────────────────────────────────────────

cena "Covil do Dragão":
    narracao "O calor te atinge como uma parede antes mesmo de você entrar."
    narracao "O covil é imenso. Ossos de cavalos, cavaleiros e criaturas maiores formam o chão."
    narracao "No centro, enrolado sobre uma montanha de ouro derretido, o Dragão Escarlate dorme."
    narracao "Seus pulmões se expandem e contraem como fuoles de ferreiro."
    narracao "Então um olho abre. Dourado. Fendido. Te encarando."
    narracao "'Outro inseto veio me incomodar', ele ronca, levantando a cabeça do tamanho de uma carroça."
    se tem_item "Pergaminho Antigo" entao:
        narracao "Você saca o Pergaminho Antigo e pronuncia as sílabas com precisão: Karath sul."
        narracao "O dragão congela. Seus olhos ficam vazios por um segundo — memória ancestral, terror primordial."
        se tem_item "Escudo Mágico" entao:
            narracao "Com o escudo levantado, você avança no momento de hesitação do dragão."
            narracao "Ele tenta soprar fogo. As chamas batem no escudo e se dispersam em faíscas inofensivas."
            escolha "Atacar a garganta — o ponto fraco revelado pelo pergaminho!" vai_para "Vitória Épica"
            escolha "Falar com o dragão enquanto ele ainda está hesitante" vai_para "Aliança Inesperada"
        senao:
            narracao "Sem escudo, você está exposto. O dragão começa a se recuperar do choque."
            escolha "Atacar agora, antes que ele se recupere!" vai_para "Vitória às Custas"
            escolha "Recuar enquanto ainda pode" vai_para "Recuo Honroso"
        fim_se
    senao:
        se tem_item "Nome Proibido" entao:
            narracao "Você respira fundo e tenta reproduzir o nome gravado na sua palma: Karath sul."
            narracao "O dragão hesita por um instante — mas sem o pergaminho, a pronúncia foi imprecisa."
            narracao "A hesitação dura menos que um batimento de coração. Ainda assim, é uma abertura."
            se tem_item "Escudo Mágico" entao:
                narracao "Você avança com o escudo levantado. O dragão reage — as chamas são contidas, mas a força do impacto te derruba."
                narracao "Ferido, você ainda consegue desferir um golpe certeiro antes de cair."
                escolha "Usar todas as forças que restam no golpe final" vai_para "Vitória Mortal"
                escolha "Recuar — uma abertura não é suficiente" vai_para "Recuo Honroso"
            senao:
                narracao "Sem proteção, o fogo parcialmente contido ainda te alcança."
                narracao "Você fere o dragão — mas o preço é alto demais."
                escolha "Continuar mesmo ferido — é agora ou nunca" vai_para "Vitória Mortal"
                escolha "Fugir enquanto ainda consegue se mover" vai_para "Recuo Honroso"
            fim_se
        senao:
            se tem_item "Escudo Mágico" entao:
                narracao "Você levanta o escudo. O dragão sopra fogo — o escudo aguenta, mas você é empurrado para trás."
                narracao "Você não sabe o ponto fraco. Pode defender, mas não atacar de forma eficaz."
                escolha "Continuar defendendo e esperar uma abertura" vai_para "Empate Exaustivo"
                escolha "Recuar pela porta antes que o escudo ceda" vai_para "Recuo Honroso"
            senao:
                narracao "Sem escudo e sem o conhecimento do pergaminho, você não tem nenhuma vantagem."
                narracao "O dragão inclina a cabeça, quase com pena."
                narracao "'Corajoso. Mas estúpido.'"
                narracao "O fogo vem. Em segundos, tudo acaba."
                narracao "[ FIM — Consumido pelas Chamas ]"
                escolha "Jogar novamente" vai_para "Menu Principal"
            fim_se
        fim_se
    fim_se

// ─────────────────────────────────────────────
// FINAIS
// ─────────────────────────────────────────────

cena "Vitória Épica":
    narracao "O golpe é certeiro. O Dragão Escarlate ruge uma última vez — um som que ecoa por toda a masmorra."
    narracao "Ele tomba. O chão treme. Poeira e cinzas enchem o ar por minutos."
    narracao "Quando a fumaça baixa, você está de pé."
    narracao "Sozinho. Ofegante. Vivo."
    narracao "Na sua mão, uma escama vermelha como brasa — prova para o reino do que aconteceu aqui."
    narracao "Bardos cantarão seu nome. Crianças aprenderão sua história. Reis pedirão sua audiência."
    narracao "[ FIM — O Herói Lendário ]"
    escolha "Jogar novamente" vai_para "Menu Principal"

cena "Aliança Inesperada":
    narracao "Para a sua própria surpresa, você fala. E o dragão... ouve."
    narracao "'Séculos', ele diz com uma voz como pedras rolando. 'Faz séculos que ninguém sabia esse nome.'"
    narracao "'Os humanos de agora não estudam mais. Não merecem respeito. Mas você...'"
    narracao "Há uma longa pausa."
    narracao "'Vá embora. Diga ao seu reino que o Dragão Escarlate dorme. E desta vez, deixem-me em paz.'"
    narracao "Você sai pela masmorra com passos lentos, esperando a qualquer momento sentir o calor nas costas."
    narracao "Mas o calor nunca vem."
    narracao "[ FIM — A Paz que Ninguém Esperava ]"
    escolha "Jogar novamente" vai_para "Menu Principal"

cena "Vitória às Custas":
    narracao "O ataque pega o dragão no meio da hesitação. O golpe na garganta é real."
    narracao "Mas ele reage antes que você possa recuar. Uma garra te acerta de raspão."
    narracao "Você acorda dois dias depois, na beira da estrada, sem saber como chegou lá."
    narracao "Nas suas mãos, sangue seco — e na sua bolsa, uma escama que prova o impossível."
    narracao "A ferida vai cicatrizar. A história, nunca."
    narracao "[ FIM — Vitória com Cicatriz ]"
    escolha "Jogar novamente" vai_para "Menu Principal"

cena "Empate Exaustivo":
    narracao "Por horas, você defende. O dragão ataca. O escudo segura."
    narracao "Eventualmente, o dragão para. Cansado ou entediado, impossível saber."
    narracao "'Você é persistente, inseto. Isso te salva hoje.'"
    narracao "Ele se vira e volta para a montanha de ouro."
    narracao "Você sai caminhando de costas, com o escudo ainda levantado, até sumir pela porta."
    narracao "O dragão ainda vive. Mas você também."
    narracao "[ FIM — O Empate do Sobrevivente ]"
    escolha "Jogar novamente" vai_para "Menu Principal"

cena "Morte no Corredor":
    narracao "Você avança às cegas, uma mão na parede de pedra fria."
    narracao "O corredor desce cada vez mais íngreme. Você não vê o degrau quebrado."
    narracao "A queda é rápida. O impacto, não."
    narracao "Lá embaixo, no escuro total, ninguém vai te encontrar."
    narracao "[ FIM — Engolido pela Escuridão ]"
    escolha "Jogar novamente" vai_para "Menu Principal"

cena "Vitória Mortal":
    narracao "O golpe atravessa as escamas do pescoço do dragão."
    narracao "Um rugido que abala as paredes. O chão treme. O dragão tomba."
    narracao "Você também cai. As queimaduras são profundas. Você sente que não vai sair daqui."
    narracao "Mas enquanto sua visão escurece, você vê o dragão imóvel."
    narracao "Você venceu. Ninguém vai saber. E não importa."
    narracao "[ FIM — O Sacrifício do Herói Desconhecido ]"
    escolha "Jogar novamente" vai_para "Menu Principal"

cena "Recuo Honroso":
    narracao "Você foge pelo corredor, o rugido do dragão abalando as paredes atrás de você."
    narracao "Pedras caem do teto. Chamas lambem seus calcanhares."
    narracao "Você sai pela entrada da masmorra em disparada e não para de correr por uma hora."
    narracao "No reino, ninguém acredita na sua história."
    narracao "Mas você sabe o que viu. E sabe que, da próxima vez, vai voltar preparado."
    narracao "[ FIM — O Aventureiro que Voltará ]"
    escolha "Jogar novamente" vai_para "Menu Principal"
