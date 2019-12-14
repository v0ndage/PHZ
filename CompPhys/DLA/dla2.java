//Simulates DLA cluster growth
//Johnathan von der Heyde 2019
import java.security.SecureRandom;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.Math; 

public class dla3 {

	static SecureRandom rand = new SecureRandom();

    static int max = 100;
    static int walkers = 50;
    static int clusterX[] = new int[max];
    static int clusterY[] = new int[max];

    static int atoms=0, atomX, atomY, t, steps=1000;

    public static void main(String[] args) {

    	int i, j, rand;
    	double radius, diffX, diffY, doubX;

    	clusterX[0] = clusterY[0] = 1;
    	clusterX[1] = clusterY[1] = 1;

    	while (atoms<max-1) {

    		System.out.println(atoms);

    		radius=0.0;

    		for (i=0; i<atoms; i++) {

				if (Math.abs(clusterX[i])>radius) {
					radius=Math.abs(clusterX[i]);
				}
				if (Math.abs(clusterY[i])>radius) {
					radius=Math.abs(clusterY[i]);
    			}
    		}

    		radius+=5;

    	 converge:

    		for (int w=0; w<walkers; w++) {

    			//System.out.println(returnRandomDouble(0.0,1.0));

    			doubX = (returnRandomDouble()*radius);

    			//System.out.println(doubX);

    			atomX = (int)doubX;
    			if (returnRandomInt(0,1)==1) atomX *= -1;

    			atomY = (int)(Math.sqrt(radius*radius - doubX*doubX));
    			if (returnRandomInt(0,1)==1) atomY *= -1;

    			for (t=0; t<steps; t++) {

    				rand = returnRandomInt(1,4);

    				switch (rand) {
    					case 1: atomX++; break;
    					case 3: atomX--; break;
    					case 2: atomY++; break;
    					case 4: atomY--; break;
    				}

    				for (i=0; i<atoms; i++) {

    					diffX = atomX - clusterX[i];
    					diffY = atomY - clusterY[i];
    					
    					if (Math.sqrt((diffX*diffX)+(diffY*diffY))<=1.00001) {
    						System.out.println("converge");
    						break converge;
    					}
    					else continue converge;
					}
    			}
    		}

			atoms++;

    		clusterX[atoms] = atomX;
    		clusterY[atoms] = atomY;
    	}

    	writeGrid();
	}

    static void writeGrid(){

    	try { FileWriter out = new FileWriter("2dout");

    		for (int i=0; i<atoms; i++) {

    			out.write(clusterX[i] + "," + clusterY[i] + "\n");
    		}

    	    out.close();
        }
        
        catch (IOException e) {e.printStackTrace();}
    }

    static int getInt() {
	    Scanner scr = new Scanner(System.in);
	    while (!scr.hasNextInt())
	        scr.next();
	    return scr.nextInt();
    }


    static Double returnRandomDouble() {
        return rand.nextDouble();
    }

    static int returnRandomInt(int a, int b) {
        return rand.nextInt(b-a+1)+a;
    }
}