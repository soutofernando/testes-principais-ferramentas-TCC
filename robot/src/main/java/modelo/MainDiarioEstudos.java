package modelo;

/* 
 * Associacao e composi��o
 * Por: L�via Sampaio Campos
 * Observacao: Esse codigo � uma prova de conceito,
 * portanto, pode estar incompleto ou com algumas 
 * simplifica��es.
 */
import java.util.Scanner;

public class MainDiarioEstudos {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		final String MENU = "1- adicionar anotacao;\n"+
							"2- pesquisar i-esima anotacao;\n"+
							"3- listar anotacoes;\n"+
							"4- mediaAvaliacoes; \n"+
							"5- sair";
		final int ANOTAR = 1;
		final int PESQUISAR = 2;
		final int LISTAR = 3;
		final int AVALIACOES = 4;
		final int SAIR = 5;
		
		int op;
		//cria Diario
		FachadaDiario diarioDeBordo = new FachadaDiario("Livia", 2021);
		
		//manipular diario
		do{
			op = leInt(MENU, sc);
			switch(op){
			case ANOTAR:
				anotar(sc, diarioDeBordo);
				break;
			case PESQUISAR:
				pesquisar(sc, diarioDeBordo);
				break;
			case LISTAR:
				listar(diarioDeBordo);
				break;
			case AVALIACOES:
				mediaAvaliacoes(diarioDeBordo);
				break;
			case SAIR:
				break;
			default:
				System.out.println("Opcao invalida!");
			}
		}while(op != SAIR);
		sc.close();	
	}//main
	
	private static void mediaAvaliacoes(FachadaDiario diario) {
		System.out.println(diario.meuDesempenho());
		
	}

	private static void pesquisar(Scanner sc, FachadaDiario diario) {
		int index = leInt("Qual o index? ", sc);
		System.out.println(diario.pesquisaAnotacao(index));
		
	}

	private static void listar(FachadaDiario diario) {
		System.out.println(diario.listarAnotacoes());
	}
	private static boolean anotar(Scanner sc, FachadaDiario diario) {
		String texto = leLinha("Qual o texto? ", sc);
		String data = leLinha("Qual a data? ", sc);
		String avaliacao = leLinha("Qual a sua autoavaliacao? ", sc);

		if(avaliacao.equals("")) {
			return diario.adicionarAnotacao(texto, data);
		}else {
			return diario.adicionarAnotacao(texto, data, Double.parseDouble(avaliacao));
		}
		
	}

	private static String leLinha(String msg, Scanner input){
		System.out.println(msg);
		return input.nextLine();
	}

	private static int leInt(String msg, Scanner input){
		System.out.println(msg);
		int op = input.nextInt();
		input.nextLine();
		return op;
	}
}
