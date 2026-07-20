package modelo;

import java.util.ArrayList;
/* 
 * Associacao e composi??o
 * Por: L?via Sampaio Campos
 * Observacao: Esse codigo ? uma prova de conceito,
 * portanto, pode estar incompleto ou com algumas 
 * simplifica??es.
 */
public class DiarioEstudos {
	private ArrayList<Anotacao> anotacoes;
	private String dono;
	private int ano;
	
	public DiarioEstudos(String dono, int ano) {
		anotacoes = new ArrayList<Anotacao>();
		this.dono = dono;
		this.ano = ano;
	}
	
	public boolean anotar(String texto, String data) {
		return anotacoes.add(new Anotacao(texto, data));
	}
	
	public boolean anotar(String texto, String data, double avaliacao) {
		return anotacoes.add(new Anotacao(texto, data, avaliacao));
	}
	public String listarDiario() {
		String resultado = dono + "/" + ano;
		for (int i = 0; i < anotacoes.size(); i++) {
			resultado += " " + anotacoes.get(i).toString().replace("\n", " ");
		}
		return resultado;
	}
	
	@Override
	public String toString() {
		return dono +"/" + ano +" - " + 
	anotacoes.size() + " anotacoes.";
	}
	
	public String pesquisar(int index) {
		//testar tambem se index esta dentro dos limites do array
		if(index >= anotacoes.size()) {
			return "INVALIDO";
		}
		return anotacoes.get(index).getTexto();
	}
	
	public String statusCompreensao(int index) {
		if(anotacoes.get(index)==null) {
			return "VAZIO";
		}
		return anotacoes.get(index).situacaoDesempenho();
	}
	
	public double mediaCompreensao() {
		if(anotacoes.size() == 0) {
			return 0;
		}
		double soma = 0;
		for (int i = 0; i < anotacoes.size(); i++) {
			soma += anotacoes.get(i).getAvaliacao();
		}
		return soma/anotacoes.size();
	}

}
