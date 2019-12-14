//Simulates DLA cluster growth
//Johnathan von der Heyde 2019
import java.security.SecureRandom;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.Math; 

public class grid2d {

    static int max = 100;
    static int iteration = 3000;
    static double grid[][] = new double[max][max];
	static SecureRandom rand = new SecureRandom();

    public static void main(String[] args) {

    	int x=max/2, y=max/2;

    	grid[x][y] = 1;

    	while (iteration>0){

    		x = returnRandomInt(0, max-1);
    		y = returnRandomInt(0, max-1);

    		while (checkNeighbors(x, y) != 2){

    			switch (returnRandomInt(1, 4)){
    				case 1: x = (x+1)%max; 	     break;
    				case 2: x = (x+max-1)%max; 	 break;
    				case 3: y = (y+1)%max; 		 break;
    				case 4: y = (y+max-1)%max; 	 break;
    			}
    		}

    		grid[x][y] = 1;

            System.out.println(iteration);

    		iteration--;
    	}

        calcFrac();

    	writeGrid();
    }

    static int checkNeighbors(int x, int y){

    	int neighbors = 0;
    	if (x > 0) neighbors += grid[x-1][y];
    	if (x < max-1) neighbors += grid[x+1][y];
    	if (y > 0) neighbors += grid[x][y-1];
    	if (y < max-1) neighbors += grid[x][y+1];
    	return neighbors;
    }

    static void calcFrac(){

        try { FileWriter out = new FileWriter("dimesnion");

            int x=0, y=0, d=1, rad=1, sum=0, mid=max/2;

            while (rad<max-1){
                while (2*x*d < rad){
                    if (grid[x+mid][y+mid]!=0) sum++;
                    x+=d;
                }
                while (2*y*d < rad){
                    if (grid[x+mid][y+mid]!=0) sum++;
                    y+=d;
                }

                d*=-1; rad++;

                out.write(Math.log(rad) + "," + Math.log(sum) + "\n");            
            }
            out.close();
        }
        catch (IOException e) {e.printStackTrace();}
    }

    static void laplace(){
        for (int x=1; x<max-1; x++) { 
            for (int y=1; y<max-1; y++) {
                grid[x][y] = 0.25*(grid[x+1][y]+grid[x-1][y]+grid[x][y+1]+grid[x][y-1]);
            }
        }
    }

    static void writeGrid(){

    	int count = 0;

    	try { FileWriter out = new FileWriter("grid2d");
    		for (int i=0; i<max; i++) {
    			for (int j=0; j<max; j++) {
    				out.write(grid[i][j] + ",");
    			}
                out.write("\n");
    		}
    	    out.close();
        }
        catch (IOException e) {e.printStackTrace();}
    }

    static int returnRandomInt(int a, int b) {
        return rand.nextInt(b-a+1)+a;
    }
}