package br.ufscar.dc.compiladores.storyflow;

import java.util.*;

/**
 * Analisador semântico do StoryFlow.
 *
 * Implementa 5 verificações que a gramática sozinha não consegue fazer:
 *   1. Cenas duplicadas            — duas cenas com o mesmo nome
 *   2. Ausência/duplicidade de inicio — deve haver exatamente uma cena marcada
 *   3. Links quebrados             — vai_para aponta para cena inexistente
 *   4. Itens fantasmas             — tem_item / pegar_item usa item não declarado
 *   5. Cenas inalcançáveis (aviso) — nenhuma escolha aponta para a cena
 */
public class StoryFlowSemantico extends StoryFlowParserBaseVisitor<Void> {

    // Dados coletados durante a travessia
    private final Set<String>              itensGlobais   = new LinkedHashSet<>();
    private final LinkedHashMap<String, Integer> cenasPorNome = new LinkedHashMap<>();
    private       String                   cenaInicio     = null;
    private       int                      contadorInicio = 0;

    // [linha, nome] de cada uso de vai_para, tem_item e pegar_item
    private final List<String[]> vaIParaUsos    = new ArrayList<>();
    private final List<String[]> temItemUsos    = new ArrayList<>();
    private final List<String[]> pegarItemUsos  = new ArrayList<>();

    private final List<String> erros  = new ArrayList<>();
    private final List<String> avisos = new ArrayList<>();

    public List<String> getErros()  { return erros; }
    public List<String> getAvisos() { return avisos; }

    // -----------------------------------------------------------------
    // Fase 1: coleta — percorre toda a árvore e acumula informações
    // Fase 2: validação — executada após o percurso, em visitPrograma
    // -----------------------------------------------------------------

    @Override
    public Void visitPrograma(StoryFlowParser.ProgramaContext ctx) {
        visitChildren(ctx); // coleta

        // Regra 1 — cenas com nome duplicado
        cenasPorNome.forEach((nome, count) -> {
            if (count > 1)
                erros.add("Erro semântico: cena \"" + nome + "\" declarada " + count + " vezes.");
        });

        // Regra 2 — exatamente uma cena inicio
        if (contadorInicio == 0)
            erros.add("Erro semântico: nenhuma cena marcada como 'inicio'. Use 'cena \"Nome\" inicio:'.");
        else if (contadorInicio > 1)
            erros.add("Erro semântico: múltiplas cenas marcadas como 'inicio' (" + contadorInicio + "). Apenas uma é permitida.");

        Set<String> cenas = cenasPorNome.keySet();

        // Regra 3 — links quebrados (vai_para → cena inexistente)
        for (String[] uso : vaIParaUsos) {
            if (!cenas.contains(uso[1]))
                erros.add("Erro semântico [linha " + uso[0] + "]: link quebrado — a cena \"" + uso[1] + "\" não existe.");
        }

        // Regra 4 — itens fantasmas (tem_item / pegar_item → item não declarado)
        for (String[] uso : temItemUsos) {
            if (!itensGlobais.contains(uso[1]))
                erros.add("Erro semântico [linha " + uso[0] + "]: item fantasma — \"" + uso[1] + "\" não declarado em itens_globais.");
        }
        for (String[] uso : pegarItemUsos) {
            if (!itensGlobais.contains(uso[1]))
                erros.add("Erro semântico [linha " + uso[0] + "]: item fantasma — \"" + uso[1] + "\" não declarado em itens_globais.");
        }

        // Regra 5 — cenas inalcançáveis (apenas aviso, não bloqueia compilação)
        // Só faz sentido verificar se não houve outros erros que comprometam os dados
        if (erros.isEmpty() && contadorInicio == 1) {
            Set<String> alvos = new HashSet<>();
            for (String[] uso : vaIParaUsos) alvos.add(uso[1]);

            for (String cena : cenas) {
                // A cena de início é sempre alcançável (é o ponto de entrada)
                if (!cena.equals(cenaInicio) && !alvos.contains(cena))
                    avisos.add("Aviso: a cena \"" + cena + "\" é inalcançável (nenhuma escolha aponta para ela).");
            }
        }

        return null;
    }

    @Override
    public Void visitItens_globais(StoryFlowParser.Itens_globaisContext ctx) {
        ctx.itens.forEach(token -> itensGlobais.add(stripQuotes(token.getText())));
        return null;
    }

    @Override
    public Void visitCena(StoryFlowParser.CenaContext ctx) {
        String nome = stripQuotes(ctx.nome.getText());
        cenasPorNome.merge(nome, 1, Integer::sum);
        if (ctx.INICIO() != null) {
            contadorInicio++;
            cenaInicio = nome;
        }
        return visitChildren(ctx);
    }

    @Override
    public Void visitEscolha(StoryFlowParser.EscolhaContext ctx) {
        String linha   = String.valueOf(ctx.start.getLine());
        String destino = stripQuotes(ctx.nomeCena.getText());
        vaIParaUsos.add(new String[]{linha, destino});

        if (ctx.PEGAR_ITEM() != null) {
            String item = stripQuotes(ctx.nomeItem.getText());
            pegarItemUsos.add(new String[]{linha, item});
        }
        return null;
    }

    @Override
    public Void visitCondicional(StoryFlowParser.CondicionalContext ctx) {
        String linha = String.valueOf(ctx.start.getLine());
        String item  = stripQuotes(ctx.nomeItemCond.getText());
        temItemUsos.add(new String[]{linha, item});
        return visitChildren(ctx); // verifica instrucoes aninhadas
    }

    // -----------------------------------------------------------------
    // Auxiliar: remove as aspas de uma string do token ANTLR ("texto" → texto)
    // -----------------------------------------------------------------
    private String stripQuotes(String s) {
        return s.substring(1, s.length() - 1);
    }
}
