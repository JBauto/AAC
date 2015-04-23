package ascii;

public class Rectangule extends Forma {
	private int altura;
	private int largura;
	
	public Rectangule (int pos_x, int pos_y, int largura, int altura) {
		super (pos_x,pos_y);
		this.altura=altura;
		this.largura=largura;
		
	}
	
	public int[] interseccao (int y){
		int i=0;
		
		if (pos_y==y) {
			int [] points = new int[largura];
			for (i=0;i<largura;i++) {
				points[i] = pos_x+i;
			}
			return points;
		}
		
		if (y > pos_y && y < altura+pos_y ){
			int [] points = new int[2];
			points [0]= pos_x;
			points [1]= pos_x+largura;
			return points;
		}
		
		if (pos_y+altura==y) {
			int [] points = new int[largura];
			for (i=0;i<largura;i++) {
				points[i] = pos_x+i;
			}
			return points;
		}
		return null;

	}
}
