//Johnathan von der Heyde 2019
//Simulates DLA cluster growth 
import java.security.SecureRandom;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.Math; 

public class x2d {

    static int max = 50;
    static int iteration = 10000;
    static int grid[][] = new int[max][max];
	static SecureRandom rand = new SecureRandom();

    public static void main(String[] args) {

    	int x=max/2, y=max/2, count=0;

        grid[x][y] = grid[x+1][y] = grid[x][y+1] = grid[x-1][y] = grid[x][y-1] = 1;
        grid[x+1][y+1] = grid[x+1][y+1] = grid[x-1][y-1] = grid[x-1][y-1] = 1;

    	while (count<iteration){

    		x = returnRandomInt(0, max-1);
    		y = returnRandomInt(0, max-1);

    		while (checkNeighbors(x, y) <=1){

    			switch (returnRandomInt(1, 4)){
    				case 1: x = (x+1)%max; 	     break;
    				case 2: x = (x+max-1)%max; 	 break;
    				case 3: y = (y+1)%max; 		 break;
    				case 4: y = (y+max-1)%max; 	 break;
    			}
    		}

    		grid[x][y] = 1;
            System.out.println(count);
    		count++;
    	}

        calcFrac();

    	writeGrid();
    }

    static int checkNeighbors(int x, int y){

    	int neighbors = 0;
    	if (x > 0) neighbors += grid[x-1][y];
        else grid[x][y]=0;
    	if (x < max-1) neighbors += grid[x+1][y]; 
        else grid[x][y]=0;
    	if (y > 0) neighbors += grid[x][y-1];
        else grid[x][y]=0;
        if (y < max-1) neighbors += grid[x][y+1];
        else grid[x][y]=0;
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

    static void writeGrid(){

    	int count = 0;

    	try { FileWriter out = new FileWriter("grid");
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