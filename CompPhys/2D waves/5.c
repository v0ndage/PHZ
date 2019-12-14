//Johnathan von der Heyde - 2019
//Simulates 1D wave propogation on string over time.
#include <stdio.h>
#include <math.h>
#define length 100
#define height 3

double w[length+1][height+1];

int main(){

    int x, y, t = 0;
    double amp = 0.5;
    double alpha = 0.1;  // 1 / wavelength or frequency
    double xi, x0 = 5;  //xi / starting position

 //initial conditions
    for (x=1; x<length; x++){
        xi = 0.1 * (x-1);

        //w[x][1] = amp*sin(alpha*(x));     //sinusoidial
        w[x][1] = amp*exp(-alpha*(pow((xi-x0),2)));  //Gaussian
        //w[x][1] = -amp*(xi-x0)*exp(-alpha*(pow((xi-x0),2)));  //derivative
        w[x][2] = w[x][1];
    }

 //boundary case
    w[0][2] = w[0][height] = 0.0;
    w[length][2] = w[length][height] = 0.0;    

    FILE* f = fopen("wave", "w");

 //main loop
    while(t<100){

        for (x=1; x<length; x++)
            w[x][height] = w[x+1][2] + w[x-1][2] - w[x][1];

        for (x=1; x<length; x++){
            w[x][1] = w[x][2];
            w[x][2] = w[x][height];
        }
        for (x=1; x<length; x++)                // adjustible time extension
            fprintf(f, "%.6lf ", w[x][height]); // + (double)((double)t/4.0));

        fprintf(f, "\n");
        t++;
    }

    fclose(f);

    return 0;
}