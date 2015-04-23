package ascii;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Image {
	private int altura;
	private int largura;	
	public List<Forma> lista_forma;
	
	public Image (int alt, int larg){
		lista_forma = new LinkedList<Forma>();
		this.altura=alt;
		this.largura=larg;
	}
	
	public void adicionarForma (Forma f){
		lista_forma.add(f);
	}
	
	
	public String linha (int y){
		int[] points = null;
		String p = "111 ";
		int j,i=0;
		points = new int [lista_forma.size()];
	//	Iterator<Forma> i = lista_forma.iterator();
		while (i<lista_forma.size()) {
	    	points = lista_forma.get(i).interseccao(y);
	    	i++;
	    	for(j=0;j<points.length;j++){
	    		p= p + (char)points[j];
	    	}
	    }
		return p;
	}

	@Override
	public String toString() {
		return "Image [altura=" + altura + ", largura=" + largura + "]";
	}
	
	public static void main(String[] args) {
		String pontos;
		Image imagem = new Image(10,10);
		Rectangule rekt = new Rectangule(2,2,4,2);
		Rectangule rekt2 = new Rectangule(2,2,4,3);
		imagem.adicionarForma(rekt);
		imagem.adicionarForma(rekt2);

		pontos = imagem.linha(3);
		System.out.println(pontos);
	}
}
