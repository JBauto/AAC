package ascii;

public abstract class Forma {
	int pos_x;
	int pos_y;
	
	public Forma (int x, int y){
		pos_x=x;
		pos_y=y;
	}
	
	public abstract int[] interseccao(int y);
}
