package steps;

import io.cucumber.java.Before;
import io.cucumber.java.pt.Entao;
import io.cucumber.java.pt.Quando;
import modelo.FachadaDiario;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class DiarioSteps {

    private FachadaDiario diario;

    @Before
    public void setup() {
        diario = new FachadaDiario("Teste", 2026);
    }

    @Quando("adiciono anotacao texto {string} data {string}")
    public void adicionarAnotacao(String texto, String data) {
        diario.adicionarAnotacao(texto, data);
    }

    @Quando("adiciono anotacao texto {string} data {string} avaliacao {word}")
    public void adicionarAnotacaoComAvaliacao(String texto, String data, String avaliacao) {
        diario.adicionarAnotacao(texto, data, Double.parseDouble(avaliacao));
    }

    @Entao("espero {string} pesquisaAnotacao index {int}")
    public void esperarPesquisaAnotacao(String esperado, int index) {
        assertEquals(esperado, diario.pesquisaAnotacao(index));
    }

    @Entao("espero {string} listarAnotacoes")
    public void esperarListarAnotacoes(String esperado) {
        assertEquals(esperado, diario.listarAnotacoes());
    }

    @Entao("espero {word} meuDesempenho")
    public void esperarMeuDesempenho(String esperado) {
        assertEquals(Double.parseDouble(esperado), diario.meuDesempenho());
    }

    @Entao("espero {string} statusCompreensao index {int}")
    public void esperarStatusCompreensao(String esperado, int index) {
        assertEquals(esperado, diario.statusCompreensao(index));
    }
}
