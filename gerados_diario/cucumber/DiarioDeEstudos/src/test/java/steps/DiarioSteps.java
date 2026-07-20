package steps;

import io.cucumber.java.Before;
import io.cucumber.java.pt.Entao;
import io.cucumber.java.pt.Quando;
import modelo.FachadaDiario;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class DiarioSteps {

    private static final double DELTA = 0.01;

    private FachadaDiario app;
    private Boolean ultimoResultado;

    @Before
    public void setup() {
        app = new FachadaDiario("Teste", 2026);
        ultimoResultado = null;
    }

    @Quando("adiciono anotacao texto {string} data {string}")
    public void adicionarAnotacao(String texto, String data) {
        ultimoResultado = app.adicionarAnotacao(texto, data);
    }

    @Quando("adiciono anotacao texto {string} data {string} avaliacao {word}")
    public void adicionarAnotacaoComAvaliacao(String texto, String data, String avaliacao) {
        ultimoResultado = app.adicionarAnotacao(texto, data, Double.parseDouble(avaliacao));
    }

    @Entao("adicionar anotacao deve retornar true")
    public void adicionarAnotacaoDeveRetornarTrue() {
        assertTrue(ultimoResultado);
    }

    @Entao("espero {string} pesquisaAnotacao index {int}")
    public void esperarPesquisaAnotacao(String esperado, int index) {
        assertEquals(esperado, app.pesquisaAnotacao(index));
    }

    @Entao("espero {string} listarAnotacoes")
    public void esperarListarAnotacoes(String esperado) {
        assertEquals(esperado, app.listarAnotacoes());
    }

    @Entao("espero {word} meuDesempenho")
    public void esperarMeuDesempenho(String esperado) {
        assertEquals(Double.parseDouble(esperado), app.meuDesempenho(), DELTA);
    }

    @Entao("espero {string} statusCompreensao index {int}")
    public void esperarStatusCompreensao(String esperado, int index) {
        assertEquals(esperado, app.statusCompreensao(index));
    }
}
