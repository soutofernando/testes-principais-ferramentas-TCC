package modelo;

/* 
 * Associacao e composi��o
 * Por: L�via Sampaio Campos
 * Observacao: Esse codigo � uma prova de conceito,
 * portanto, pode estar incompleto ou com algumas 
 * simplifica��es.
 */
public class FachadaDiario {

	private DiarioEstudos diario;
	
	public FachadaDiario() {
		this("Teste", 2026);
	}

	public FachadaDiario(String dono, int ano) {
		diario = new DiarioEstudos(dono, ano);
	}
	
	public boolean adicionarAnotacao(String texto, String data) {
		return diario.anotar(texto, data);
	}
	
	public boolean adicionarAnotacao(String texto, String data, double avaliacao) {
		return diario.anotar(texto, data, avaliacao);
	} 
	
	public String pesquisaAnotacao(int index) {
		return diario.pesquisar(index);
	}
	
	public String listarAnotacoes() {
		return diario.listarDiario();
	}
	
	public double meuDesempenho() {
		return diario.mediaCompreensao();
	}
	
	public String statusCompreensao(int index) {
		return diario.statusCompreensao(index);
	}
}
