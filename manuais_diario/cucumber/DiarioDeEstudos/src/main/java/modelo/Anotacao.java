package modelo;

/* 
 * Associacao e composi��o
 * Por: L�via Sampaio Campos
 * Observacao: Esse codigo � uma prova de conceito,
 * portanto, pode estar incompleto ou com algumas 
 * simplifica��es.
 */
public class Anotacao {
	private String data;
	private String texto;
	private double autoAvaliacao;
	
	public Anotacao(String texto, String data){
		this(texto, data, 0);
	}
	
	public Anotacao(String texto, String data, double autoAvaliacao){
		this.data = data;
		this.texto = texto;
		this.autoAvaliacao = autoAvaliacao;
	}
	
	public String getData(){
		return data;
	}

	public String getTexto(){
		return texto;
	}
	
	public double getAvaliacao(){
		return autoAvaliacao;
	}
	
	public void setTexto(String novo){
		texto = novo;
	}
	
	public void setAvaliacao(double novo){
		autoAvaliacao = novo;
	}
	
	@Override
		public String toString() {
		return "Data: " + this.getData() + "\n" +
				"Texto: " + this.texto;
		}
	
	public String situacaoDesempenho(){
		if(autoAvaliacao > 0 && autoAvaliacao <= 5){
			return "REGULAR";
		}else if(autoAvaliacao > 5 && autoAvaliacao <= 7){
			return "BOM";
		}else if(autoAvaliacao > 7 && autoAvaliacao < 9){
			return "MUITO BOM";
		}else if(autoAvaliacao >= 9 && autoAvaliacao <= 10){
			return "EXCELENTE";
		}else{
			return "ATENCAO!";
		}
	}
	
}
