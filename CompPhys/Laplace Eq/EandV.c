//Johnathan von der Heyde 2019
//This program models the electrostatic potential between adjustable capacitor plate bounds

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define max 100                      //dimension of the grid
#define Lheight max/2               //this eases calculations
#define Rheight -max/2
#define Linset max/4
#define Rinset max-1-max/4
#define width 30

double V[max][max], E[max][max];    //index V[0-49][0-49]
int x, y, i, iter, dist;            //coordinates and iteration vars
double dv = 0, prev, final, last;   //for checking convergence

void initialize();      //zeros the plane and sets boundary conditions
void guessedge();       //makes starting assumptions for edge values
void update(int i);     //averages coordinates and tracks convergence
void gradient();        //working...
void printPlot(int plot);          //allows us to check on V before plotting
void writeout(int plot);        //writes data to "laplace.dat"

int main() {

 //Input
   printf("Please Input # Iterations\n");
   scanf("%d", &iter);

 //Bounds
   initialize();
   guessedge();
   //printV();

 //Update
   for (i=1; i<=iter; i++) update(i);

 //Convergence
   if (fabs(final - last) > 0.00001) 
      printf("program failed to converge\n");

   gradient();
 
 //Output
   printPlot(1);
   printPlot(2);

   writeout(2);

   return 0;
}

void initialize() {

   for (x=0; x<max; x++) {
      for (y=0; y<max; y++) V[x][y] = E[x][y] = 0;
   }
}

void guessedge(){ //edge values are guessed relative to capacitor plates

   for (dist=1, i=Linset; i>0; i--, dist++)
      V[width/2][i] = V[max-1-width/2][i] = Lheight/dist;
   for (dist=1, i=Linset; i<max/2; i++, dist++)
      V[width/2][i] = V[max-1-width/2][i] = Lheight/dist;

   V[width/2][max/2] = V[max-1-width/2][max/2] = 0.0;

   for (dist=1, i=Rinset; i>max/2; i--, dist++)
      V[width/2][i] = V[max-1-width/2][i] = Rheight/dist;
   for (dist=1, i=Rinset; i<max-1; i++, dist++)
      V[width/2][i] = V[max-1-width/2][i] = Rheight/dist;
}

void update(int i) {

 //capacitor plates
   for (x=width/2; x<max-1-width/2; x++) {   //range modifies capacitor width
      V[x][Linset] = Lheight;                //inset must be < height
      V[x][Rinset] = Rheight;
   }
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
}

void gradient() {

   for (x=1; x<max-1; x++) {
      for (y=1; y<max-1; y++) {
          E[x][y] = -((V[x][y+1]-V[x][y-1])/(2))-((V[x+1][y]-V[x-1][y])/(2));
      }
   }
 //plates need manual adjustment because slope is undefined at capacitor edge
   E[width/2-1][Linset-1] = E[max-1-width/2-1][Linset-1] = 0;
   E[width/2-1][Rinset-1] = E[max-1-width/2-1][Rinset-1] = 0;
   E[width/2][Linset] = E[max-1-width/2][Linset] = 0;
   E[width/2][Rinset] = E[max-1-width/2][Rinset] = 0;
   E[width/2+1][Linset+1] = E[max-1-width/2+1][Linset+1] = 0;
   E[width/2+1][Rinset+1] = E[max-1-width/2+1][Rinset+1] = 0;
}

int isCapacitor(){

   for (x=width/2; x<max-1-width/2; x++) {
      V[x][Linset] = Lheight;
      V[x][Rinset] = Rheight;
   }
}

void printPlot(int plot) {
   printf("\n----%d\n", plot);
   for (x=0; x<max; x++) {
      for (y=0; y<max; y++) {
         if (plot==1) printf("%lf\t", V[x][y]);
         if (plot==2) printf("%lf\t", E[x][y]);
      } printf("\n");
   } printf("----%d\n", plot);
}

void writeout(int plot) {
   FILE *f;
   f = fopen("laplace.dat","w");
      for (x=0; x<max; x++) {
         for (y=0; y<max; y++) {
            if (plot==1) fprintf(f, "%lf\t", V[x][y]);
            if (plot==2) fprintf(f, "%lf\t", E[x][y]);
         }
         fprintf(f, "\n");
      }
   fclose(f);
}

//END