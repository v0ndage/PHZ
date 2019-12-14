//Johnathan von der Heyde - 2019
//Modeling Simple Pendulum with Cromer-Euler Method

#include <stdio.h>
#include <math.h>
#define PI 3.1415927
#define g 9.8		//gravitation (m/s^2)
#define l 1.0		//pendulum length (m)

int main(){

	double omega, theta, r, d;	//frequency, angle, resistance, and driving force
	double f = pow(g/l, 0.5);	//natural frequency
	double T = 2.0*PI/f;		//natural period
	double A = 1;				//visual amplitude
	double t = 0; 				//time
	double dt = 0.01;			//time step

	printf("Enter theta (degrees)\n");
	scanf("%lf", &theta); theta *= (PI/180);
	printf("Enter r (resistance)\n");
	scanf("%lf", &r);
	printf("Enter d (driving force)\n");
	scanf("%lf", &d);	 d *= f;

	FILE * file = fopen("OUT", "w");	//main loop can be configured for finite
		while (t < 500){				//time extension, or when pendulum stops

			t+=dt;
			omega -= ((g*theta/l)+(r*omega*(-A*cos(d*t))))*dt;
			theta += omega*dt;
			fprintf(file, "%f\t%f\t%f\n", theta, omega, t);
		}
	fclose(file);

	return 0;
}

//END