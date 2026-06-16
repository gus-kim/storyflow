# StoryFlow — Compilador de RPG Textual

> Trabalho 6 (T6) — Construção de Compiladores — UFSCar

StoryFlow é uma linguagem criada para escrever histórias interativas no estilo *"Escolha a sua própria aventura"*. Você escreve a história num arquivo de texto simples (`.story`), e o compilador gera um jogo jogável no navegador — sem precisar saber nada de programação.

---

## Início Rápido

```bash
# 1. Compile o compilador (apenas uma vez)
mvn clean package

# 2. Compile uma história e gere o jogo
java -jar target/storyflow-1.0-SNAPSHOT-jar-with-dependencies.jar casos-de-teste/01_aventura_completa.story jogo.html

# 3. Abra o jogo no navegador
xdg-open jogo.html        # Linux
open jogo.html            # macOS
start jogo.html           # Windows
```

---

## O que é o StoryFlow?

Criar um jogo baseado em texto normalmente exige HTML, CSS e JavaScript. O StoryFlow elimina essa barreira: o autor escreve apenas a narrativa, e o compilador cuida de todo o resto — inclusive verificando se a história não tem erros lógicos (como uma cena que nunca pode ser alcançada, ou um item que é usado sem ter sido declarado).

**Fluxo de trabalho:**

```
você escreve  →  compilador verifica  →  jogo gerado  →  abre no browser
  .story             erros/avisos          .html            e joga
```

O arquivo `.html` gerado é auto-contido: funciona offline, pode ser enviado por e-mail, compartilhado pelo Drive ou hospedado em qualquer servidor web.

---

## Escrevendo uma História

Um arquivo `.story` é um arquivo de texto comum — crie no VS Code, Notepad, Vim, qualquer editor. A linguagem tem 5 construções:

### 1. Itens Globais

Declara quais itens existem no universo do jogo. Todo item usado na história precisa estar listado aqui — isso previne erros de digitação.

```
itens_globais:
    "Tocha", "Chave Dourada", "Espada"
```

### 2. Cenas

O bloco principal da narrativa. Cada cena tem um nome único entre aspas. A cena com `inicio` é onde o jogo começa — deve existir exatamente uma.

```
cena "Floresta" inicio:
    ...

cena "Caverna":
    ...
```

### 3. Narração

Exibe um parágrafo de texto ao jogador.

```
narracao "O vento sopra entre as árvores enquanto você avança."
```

### 4. Escolha

Cria um botão clicável. Quando o jogador clica, vai para outra cena. Opcionalmente, a escolha pode adicionar um item ao inventário.

```
// Botão simples
escolha "Entrar na caverna" vai_para "Caverna"

// Botão que pega um item antes de navegar
escolha "Pegar a tocha" pegar_item "Tocha" vai_para "Caverna"
```

### 5. Condicional

Mostra coisas diferentes dependendo do que o jogador tem no inventário. O bloco termina com `fim_se`. O `senao:` é opcional.

```
se tem_item "Tocha" entao:
    narracao "Sua tocha ilumina o caminho."
    escolha "Avançar" vai_para "Tesouro"
senao:
    narracao "Está escuro demais para prosseguir."
    escolha "Voltar" vai_para "Floresta"
fim_se
```

### Comentários

```
// Linhas começando com // são ignoradas pelo compilador
```

---

## Observações Importantes

- **Strings não suportam quebra de linha** — o texto de uma `narracao`, `escolha` ou nome de cena deve caber em uma única linha. Para múltiplos parágrafos, use várias instruções `narracao` seguidas:

  ```
  narracao "O castelo era imenso e sombrio."
  narracao "Suas torres desapareciam nas nuvens."
  narracao "Ninguém entrava lá há décadas."
  ```

- **Strings não podem conter aspas duplas** — o texto vai sempre entre `"` e `"`, então não é possível usar aspas dentro dele. Se precisar de uma marca de citação, use aspas simples:
  ```
  narracao "Ele disse: 'cuidado com a armadilha!'"
  ```

- **Nomes de cenas são sensíveis a maiúsculas** — `"Sala"` e `"sala"` são cenas diferentes. Use um padrão consistente.

- **Todo item usado precisa estar em `itens_globais`** — mesmo que você só use `pegar_item` e nunca `tem_item`, o item precisa ser declarado no topo.

---

## Exemplo Completo

```
itens_globais:
    "Tocha", "Espada Lendária"

cena "Entrada da Caverna" inicio:
    narracao "Você está na entrada de uma caverna misteriosa."
    escolha "Seguir pela esquerda" vai_para "Sala Escura"
    escolha "Seguir pela direita" vai_para "Sala Iluminada"

cena "Sala Escura":
    narracao "Está completamente escuro."
    se tem_item "Tocha" entao:
        narracao "Mas sua tocha ilumina o caminho!"
        escolha "Avançar" vai_para "Tesouro"
    senao:
        escolha "Recuar" vai_para "Sala Iluminada"
    fim_se

cena "Sala Iluminada":
    narracao "Um cristal no teto ilumina tudo."
    escolha "Pegar a tocha" pegar_item "Tocha" vai_para "Sala Escura"

cena "Tesouro":
    narracao "Você encontrou o tesouro!"
    escolha "Pegar a espada" pegar_item "Espada Lendária" vai_para "Vitória"

cena "Vitória":
    narracao "Com a Espada Lendária, você se torna o herói lendário. [ FIM ]"
```

---

## Verificações Semânticas

Além da gramática, o compilador realiza 5 verificações de consistência que impedem que jogos "quebrados" sejam gerados:

| # | Regra | Tipo | O que detecta |
|---|-------|------|---------------|
| 1 | Cenas duplicadas | **Erro** | Duas cenas com o mesmo nome |
| 2 | Cena de início | **Erro** | Ausência ou duplicidade de `inicio` |
| 3 | Links quebrados | **Erro** | `vai_para` apontando para uma cena que não existe |
| 4 | Itens fantasmas | **Erro** | `tem_item` ou `pegar_item` usando item não declarado em `itens_globais` |
| 5 | Cenas inalcançáveis | *Aviso* | Cena que nunca pode ser acessada pelo jogador |

Erros (1–4) interrompem a compilação. O aviso (5) é exibido mas o jogo é gerado mesmo assim.

---

## Como Compilar o Compilador

> Este passo configura o ambiente. Você só precisa rodá-lo **uma vez** — ou quando clonar o projeto pela primeira vez.

**Pré-requisitos:** Java JDK 11+ e Apache Maven instalados.

```bash
# Na raiz do projeto (mesma pasta do pom.xml)
mvn clean package
```

Isso gera o compilador em:
```
target/storyflow-1.0-SNAPSHOT-jar-with-dependencies.jar
```

---

## Como Compilar uma História

O compilador recebe dois argumentos: o caminho do arquivo `.story` e o caminho onde o `.html` será salvo.

```bash
java -jar target/storyflow-1.0-SNAPSHOT-jar-with-dependencies.jar <entrada.story> <saida.html>
```

Os caminhos podem ser relativos ou absolutos. Exemplos:

```bash
# .story na mesma pasta onde você está
java -jar target/storyflow-1.0-SNAPSHOT-jar-with-dependencies.jar minha_historia.story jogo.html

# .story em outra pasta, .html salvo numa pasta específica
java -jar target/storyflow-1.0-SNAPSHOT-jar-with-dependencies.jar casos-de-teste/masmorra_do_dragao.story ~/Desktop/masmorra.html

# caminho absoluto
java -jar target/storyflow-1.0-SNAPSHOT-jar-with-dependencies.jar /home/user/historias/aventura.story /home/user/jogos/aventura.html
```

**Não precisa rodar o Maven de novo** — só o `java -jar` acima cada vez que alterar a história.

O `.html` gerado é auto-contido: funciona offline, pode ser enviado por e-mail ou aberto diretamente no navegador sem nenhuma instalação.

---

## Casos de Teste

A pasta `casos-de-teste/` contém exemplos prontos para demonstrar todas as funcionalidades:

| Arquivo | O que demonstra |
|---------|----------------|
| `01_aventura_completa.story` | História completa com itens, condicionais e múltiplos finais |
| `02_erro_link_quebrado.story` | Erro: `vai_para` aponta para cena inexistente |
| `03_erro_item_fantasma.story` | Erro: `tem_item` usa item não declarado |
| `04_erro_cena_duplicada.story` | Erro: dois cenas com o mesmo nome |
| `05_aviso_cena_inalcancavel.story` | Aviso: cena declarada mas inalcançável |
| `masmorra_do_dragao.story` | História elaborada com 5 finais diferentes |

---

## Estrutura do Projeto

```
storyflow/
├── pom.xml                        ← configuração do build (Maven)
├── README.md
├── casos-de-teste/                ← histórias de exemplo e testes
└── src/main/
    ├── antlr4/.../storyflow/
    │   ├── StoryFlowLexer.g4      ← gramática léxica (tokens)
    │   └── StoryFlowParser.g4     ← gramática sintática
    └── java/.../storyflow/
        ├── Principal.java          ← ponto de entrada do compilador
        ├── StoryFlowSemantico.java ← analisador semântico (padrão Visitor)
        └── StoryFlowGerador.java   ← gerador de código HTML/JS
```

---

## Autores

| Nome | RA | Turma |
|------|----|-------|
| Gustavo Kim Alcantara | 820763 | Quarta-feira |
| Gustavo Borguetti Daré | 818723 | Segunda-feira |

UFSCar — Construção de Compiladores — 2026
