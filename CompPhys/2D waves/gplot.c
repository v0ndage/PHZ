//gaussian spacetime plot

#include <stdio.h>
#include <math.h>
#define max 100

double wave[max][max];

int main(){

	FILE* f = fopen("g", "w");

	for (int t=0; t<max; t++){

		for (int x=0; x<max; x++){
			
			wave[t][x] = exp(-(pow(x-50,2)));

			if (t%10==0){

				fprintf(f, "%.6lf ", wave[t][x]);
			}
		}
		if (t%10==0)

			fprintf(f, "\n");
	}

	fclose(f);

	return 0;
}