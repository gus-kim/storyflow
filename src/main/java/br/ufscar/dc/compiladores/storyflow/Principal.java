package br.ufscar.dc.compiladores.storyflow;

import org.antlr.v4.runtime.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Principal {

    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Uso: storyflow <arquivo.story> <saida.html>");
            System.exit(1);
        }

        String arquivoEntrada = args[0];
        String arquivoSaida   = args[1];

        try {
            // --- Análise Léxica e Sintática ---
            CharStream entrada = CharStreams.fromFileName(arquivoEntrada);
            StoryFlowLexer lexer   = new StoryFlowLexer(entrada);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            StoryFlowParser parser  = new StoryFlowParser(tokens);

            // Substitui o listener padrão para formatar as mensagens de erro
            parser.removeErrorListeners();
            parser.addErrorListener(new BaseErrorListener() {
                @Override
                public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
                                        int line, int charPositionInLine,
                                        String msg, RecognitionException e) {
                    System.err.println("Erro sintático [linha " + line + ":" + charPositionInLine + "]: " + msg);
                }
            });

            StoryFlowParser.ProgramaContext arvore = parser.programa();

            if (parser.getNumberOfSyntaxErrors() > 0) {
                System.exit(1);
            }

            // --- Análise Semântica ---
            StoryFlowSemantico semantico = new StoryFlowSemantico();
            semantico.visit(arvore);

            if (!semantico.getErros().isEmpty()) {
                semantico.getErros().forEach(System.err::println);
                System.exit(1);
            }

            // Avisos não interrompem a compilação
            semantico.getAvisos().forEach(System.out::println);

            // --- Geração de Código ---
            StoryFlowGerador gerador = new StoryFlowGerador();
            String html = gerador.gerar(arvore);

            Files.writeString(Path.of(arquivoSaida), html);
            System.out.println("Jogo gerado com sucesso: " + arquivoSaida);

        } catch (IOException e) {
            System.err.println("Erro ao acessar arquivo: " + e.getMessage());
            System.exit(1);
        }
    }
}
