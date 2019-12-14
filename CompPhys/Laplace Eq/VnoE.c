//Johnathan von der Heyde 2019
//This program models the electrostatic potential between adjustable capacitor plate bounds

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define max 100                 //dimension of the grid
#define Lheight 1               //these ease calculations
#define Rheight -1              //height is value of capacitors
#define Linset 25               //inset is how close they are
#define Rinset max-1-25
#define width 25                //width is how wide (relative to edge)

double V[max][max];                       //index V[0-49][0-49]
int x, y, i, iter, count, Ldist, Rdist;   //coordinates and iteration vars
double dv = 0, prev, final, last;         //for checking convergence

void initialize();      //zeros the plane and sets boundary conditions
void guessedge();       //makes starting assumptions for edge values
void update(int i);     //averages coordinates and tracks convergence
void printV();          //allows us to check on V before plotting
void writeout();        //writes data to "laplace.dat"

int main() {
 //Input
   printf("Please Input # Iterations\n");
   scanf("%d", &iter);
 //Bounds
   initialize();
   guessedge();
 //Update
   for (i=1; i<=iter; i++) update(i);
   printV();
 //Convergence
   if (fabs(final - last) > 0.00001) 
      printf("program failed to converge\n");
 //Output
   writeout();
   return 0;
}

void initialize() {
   for (x=0; x<max; x++) {
      for (y=0; y<max; y++) V[x][y] = 0;
   }
}

void guessedge(){ //edge values are guessed relative to capacitor plates
 //0 to left capacitor
   Ldist = max/2-Linset;
   for (count=0, y=Linset; y>0; y--, count++)
      V[width/2][y] = V[max-1-width/2][y] = (double)Lheight*(1-((double)count/(double)Ldist));
 //left capacitor to middle
   for (count=0, y=Linset; y<max/2; y++, count++)
      V[width/2][y] = V[max-1-width/2][y] = (double)Lheight*(1-((double)count/(double)Ldist));
 //middle
   V[width/2][max/2] = V[max-1-width/2][max/2] = 0.0;
 //middle to right capacitor
   Rdist = Rinset-max/2;
   for (count=0, y=Rinset; y>max/2; y--, count++)
      V[width/2][y] = V[max-1-width/2][y] = (double)Rheight*(1-((double)count/(double)Rdist));
 //right capacitor to max
   for (count=0, y=Rinset; y<max-1; y++, count++)
      V[width/2][y] = V[max-1-width/2][y] = (double)Rheight*(1-((double)count/(double)Rdist));
}

void update(int i) {
 //laplace equation and convergence criteria
   prev = dv;
   for (x=1; x<max-1; x++) {
      for (y=1; y<max-1; y++) {
         V[x][y] = 0.25*(V[x+1][y]+V[x-1][y]+V[x][y+1]+V[x][y-1]);
         dv += fabs(V[x][y]);                //dv is total V per iteration
      }
   }
 //convergence tracking
   if(i==iter-1) last = fabs(dv-prev);       //saves 2nd to "last" delta V
   else final = fabs(dv-prev);               //compares that to "final" delta V

 //capacitor plates
   for (x=width/2; x<max-width/2; x++) {   //range modifies capacitor width
      V[x][Linset] = Lheight;                //inset must be < height
      V[x][Rinset] = Rheight;
   }
}

void printV() {
   printf("\n----V\n");
   for (x=0; x<max; x++) {
      for (y=0; y<max; y++) {
         printf("%2.2lf\t", V[x][y]);
      } printf("\n");
   } printf("----V\n\n");
}

void writeout() {
   FILE *f;
   f = fopen("laplace.dat","w");
      for (x=0; x<max; x++) {
         for (y=0; y<max; y++) {
            fprintf(f, "%lf\t", V[x][y]);
         }
         fprintf(f, "\n");
      }
   fclose(f);
} //END