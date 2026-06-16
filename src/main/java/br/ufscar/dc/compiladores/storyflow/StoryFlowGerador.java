package br.ufscar.dc.compiladores.storyflow;

import java.util.List;

/**
 * Gera um arquivo HTML/JS auto-contido e jogável a partir da AST do StoryFlow.
 *
 * A saída contém:
 *   - CSS com tema retro/dark embutido
 *   - JSON com os dados de todas as cenas
 *   - Engine JavaScript que renderiza e navega as cenas em tempo de execução
 */
public class StoryFlowGerador {

    public String gerar(StoryFlowParser.ProgramaContext ctx) {
        String nomeInicio = encontrarNomeInicio(ctx);
        String jsonCenas  = gerarJsonCenas(ctx);
        return montarHtml(nomeInicio, jsonCenas);
    }

    // -----------------------------------------------------------------
    // Encontra o nome da cena marcada como inicio
    // -----------------------------------------------------------------
    private String encontrarNomeInicio(StoryFlowParser.ProgramaContext ctx) {
        for (StoryFlowParser.CenaContext cena : ctx.cena()) {
            if (cena.INICIO() != null) return stripQuotes(cena.nome.getText());
        }
        return "";
    }

    // -----------------------------------------------------------------
    // Gera o objeto JSON com todas as cenas
    // -----------------------------------------------------------------
    private String gerarJsonCenas(StoryFlowParser.ProgramaContext ctx) {
        StringBuilder sb = new StringBuilder();
        sb.append("{\n");
        List<StoryFlowParser.CenaContext> cenas = ctx.cena();
        for (int i = 0; i < cenas.size(); i++) {
            if (i > 0) sb.append(",\n");
            sb.append(gerarJsonCena(cenas.get(i)));
        }
        sb.append("\n    }");
        return sb.toString();
    }

    private String gerarJsonCena(StoryFlowParser.CenaContext ctx) {
        String nome = stripQuotes(ctx.nome.getText());
        StringBuilder sb = new StringBuilder();
        sb.append("      \"").append(esc(nome)).append("\": {\n");
        sb.append("        \"instructions\": ");
        sb.append(gerarJsonInstrucoes(ctx.instrucao(), "        "));
        sb.append("\n      }");
        return sb.toString();
    }

    private String gerarJsonInstrucoes(List<StoryFlowParser.InstrucaoContext> instrucoes, String indent) {
        StringBuilder sb = new StringBuilder();
        sb.append("[\n");
        for (int i = 0; i < instrucoes.size(); i++) {
            if (i > 0) sb.append(",\n");
            sb.append(indent).append("  ").append(gerarJsonInstrucao(instrucoes.get(i), indent + "  "));
        }
        if (!instrucoes.isEmpty()) sb.append("\n").append(indent);
        sb.append("]");
        return sb.toString();
    }

    private String gerarJsonInstrucao(StoryFlowParser.InstrucaoContext ctx, String indent) {
        if (ctx.narracao()    != null) return gerarJsonNarracao(ctx.narracao());
        if (ctx.escolha()     != null) return gerarJsonEscolha(ctx.escolha());
        return gerarJsonCondicional(ctx.condicional(), indent);
    }

    private String gerarJsonNarracao(StoryFlowParser.NarracaoContext ctx) {
        return "{\"type\":\"narration\",\"text\":\"" + esc(stripQuotes(ctx.texto.getText())) + "\"}";
    }

    private String gerarJsonEscolha(StoryFlowParser.EscolhaContext ctx) {
        String texto   = esc(stripQuotes(ctx.textoEscolha.getText()));
        String pickup  = ctx.PEGAR_ITEM() != null
                         ? "\"" + esc(stripQuotes(ctx.nomeItem.getText())) + "\""
                         : "null";
        String destino = esc(stripQuotes(ctx.nomeCena.getText()));
        return "{\"type\":\"choice\",\"text\":\"" + texto
             + "\",\"pickup\":" + pickup
             + ",\"goTo\":\"" + destino + "\"}";
    }

    private String gerarJsonCondicional(StoryFlowParser.CondicionalContext ctx, String indent) {
        String item  = esc(stripQuotes(ctx.nomeItemCond.getText()));
        String entao = gerarJsonInstrucoesInline(ctx.entao);
        String senao = ctx.senao.isEmpty() ? "null" : gerarJsonInstrucoesInline(ctx.senao);
        return "{\"type\":\"conditional\",\"item\":\"" + item
             + "\",\"then\":" + entao
             + ",\"else\":" + senao + "}";
    }

    // Versão inline (sem quebras de linha extras) usada dentro de condicionais
    private String gerarJsonInstrucoesInline(List<StoryFlowParser.InstrucaoContext> instrucoes) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < instrucoes.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(gerarJsonInstrucao(instrucoes.get(i), ""));
        }
        sb.append("]");
        return sb.toString();
    }

    // -----------------------------------------------------------------
    // Monta o HTML final com CSS, dados JSON e engine JS
    // -----------------------------------------------------------------
    private String montarHtml(String nomeInicio, String jsonCenas) {
        return "<!DOCTYPE html>\n"
             + "<html lang=\"pt-BR\">\n"
             + "<head>\n"
             + "  <meta charset=\"UTF-8\">\n"
             + "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
             + "  <title>StoryFlow</title>\n"
             + "  <style>\n" + CSS + "\n  </style>\n"
             + "</head>\n"
             + "<body>\n"
             + "  <div id=\"game\">\n"
             + "    <div id=\"scene-name\"></div>\n"
             + "    <div id=\"narration\"></div>\n"
             + "    <div id=\"choices\"></div>\n"
             + "    <div id=\"inventory-bar\">Inventário: <span id=\"inv-items\">vazio</span></div>\n"
             + "  </div>\n"
             + "  <script>\n"
             + "    const STORY = {\n"
             + "      start: \"" + esc(nomeInicio) + "\",\n"
             + "      scenes: " + jsonCenas + "\n"
             + "    };\n\n"
             + JS_ENGINE
             + "\n  </script>\n"
             + "</body>\n"
             + "</html>\n";
    }

    // -----------------------------------------------------------------
    // Escapa caracteres especiais para uso dentro de strings JSON
    // -----------------------------------------------------------------
    private String esc(String s) {
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String stripQuotes(String s) {
        return s.substring(1, s.length() - 1);
    }

    // -----------------------------------------------------------------
    // CSS — tema retro/dark
    // -----------------------------------------------------------------
    private static final String CSS =
        "    * { margin: 0; padding: 0; box-sizing: border-box; }\n"
      + "    body {\n"
      + "      background: #0f0f1a;\n"
      + "      color: #cdd6f4;\n"
      + "      font-family: 'Georgia', serif;\n"
      + "      display: flex;\n"
      + "      justify-content: center;\n"
      + "      min-height: 100vh;\n"
      + "      padding: 48px 20px;\n"
      + "    }\n"
      + "    #game {\n"
      + "      max-width: 720px;\n"
      + "      width: 100%;\n"
      + "    }\n"
      + "    #scene-name {\n"
      + "      font-size: 11px;\n"
      + "      letter-spacing: 4px;\n"
      + "      text-transform: uppercase;\n"
      + "      color: #45475a;\n"
      + "      margin-bottom: 32px;\n"
      + "      padding-bottom: 12px;\n"
      + "      border-bottom: 1px solid #1e1e2e;\n"
      + "    }\n"
      + "    #narration {\n"
      + "      min-height: 80px;\n"
      + "      margin-bottom: 40px;\n"
      + "    }\n"
      + "    #narration p {\n"
      + "      line-height: 1.9;\n"
      + "      color: #cdd6f4;\n"
      + "      margin-bottom: 14px;\n"
      + "    }\n"
      + "    #choices {\n"
      + "      display: flex;\n"
      + "      flex-direction: column;\n"
      + "      gap: 10px;\n"
      + "    }\n"
      + "    .btn {\n"
      + "      background: transparent;\n"
      + "      border: 1px solid #313244;\n"
      + "      color: #89b4fa;\n"
      + "      font-family: 'Georgia', serif;\n"
      + "      font-size: 15px;\n"
      + "      padding: 13px 18px;\n"
      + "      cursor: pointer;\n"
      + "      text-align: left;\n"
      + "      transition: background 0.15s, border-color 0.15s, color 0.15s;\n"
      + "    }\n"
      + "    .btn::before { content: '› '; color: #313244; }\n"
      + "    .btn:hover {\n"
      + "      background: #1e1e2e;\n"
      + "      border-color: #89b4fa;\n"
      + "      color: #cdd6f4;\n"
      + "    }\n"
      + "    .btn:hover::before { color: #89b4fa; }\n"
      + "    #inventory-bar {\n"
      + "      margin-top: 52px;\n"
      + "      padding-top: 16px;\n"
      + "      border-top: 1px solid #1e1e2e;\n"
      + "      font-size: 12px;\n"
      + "      color: #45475a;\n"
      + "      letter-spacing: 1px;\n"
      + "    }\n"
      + "    #inv-items { color: #a6e3a1; }\n"
      + "    .game-over {\n"
      + "      color: #45475a;\n"
      + "      font-style: italic;\n"
      + "      margin-top: 24px;\n"
      + "    }";

    // -----------------------------------------------------------------
    // JS ENGINE — gerencia estado, renderiza cenas e navega o jogo
    // -----------------------------------------------------------------
    private static final String JS_ENGINE =
        "    const inventory = [];\n"
      + "    let currentScene = STORY.start;\n\n"
      + "    function renderScene(sceneId) {\n"
      + "      const scene = STORY.scenes[sceneId];\n"
      + "      document.getElementById('scene-name').textContent = sceneId;\n"
      + "      document.getElementById('narration').innerHTML = '';\n"
      + "      document.getElementById('choices').innerHTML = '';\n\n"
      + "      if (!scene) {\n"
      + "        document.getElementById('narration').innerHTML = '<p class=\"game-over\">[ A história chegou ao fim ]</p>';\n"
      + "        return;\n"
      + "      }\n\n"
      + "      scene.instructions.forEach(renderInstruction);\n"
      + "      updateInventory();\n\n"
      + "      if (document.getElementById('choices').children.length === 0) {\n"
      + "        const p = document.createElement('p');\n"
      + "        p.className = 'game-over';\n"
      + "        p.textContent = '[ Fim da história ]';\n"
      + "        document.getElementById('choices').appendChild(p);\n"
      + "      }\n"
      + "    }\n\n"
      + "    function renderInstruction(instr) {\n"
      + "      if (instr.type === 'narration') {\n"
      + "        const p = document.createElement('p');\n"
      + "        p.textContent = instr.text;\n"
      + "        document.getElementById('narration').appendChild(p);\n"
      + "      } else if (instr.type === 'choice') {\n"
      + "        addButton(instr);\n"
      + "      } else if (instr.type === 'conditional') {\n"
      + "        const branch = inventory.includes(instr.item) ? instr.then : instr.else;\n"
      + "        if (branch) branch.forEach(renderInstruction);\n"
      + "      }\n"
      + "    }\n\n"
      + "    function addButton(instr) {\n"
      + "      const btn = document.createElement('button');\n"
      + "      btn.className = 'btn';\n"
      + "      btn.textContent = instr.text;\n"
      + "      btn.onclick = () => {\n"
      + "        if (instr.pickup && !inventory.includes(instr.pickup))\n"
      + "          inventory.push(instr.pickup);\n"
      + "        renderScene(instr.goTo);\n"
      + "      };\n"
      + "      document.getElementById('choices').appendChild(btn);\n"
      + "    }\n\n"
      + "    function updateInventory() {\n"
      + "      const el = document.getElementById('inv-items');\n"
      + "      el.textContent = inventory.length === 0 ? 'vazio' : inventory.join(', ');\n"
      + "    }\n\n"
      + "    renderScene(currentScene);";
}
