#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#define N				10000
#define smooth	4

double randn (double mu, double sigma){
	double U1, U2, W, mult;
	static double X1, X2;
	static int call = 0;

	if (call == 1){
		call = !call;
		return (mu + sigma * (double) X2);
	}
	do{
		U1 = -1 + ((double) rand () / RAND_MAX) * 2;
		U2 = -1 + ((double) rand () / RAND_MAX) * 2;
		W = pow (U1, 2) + pow (U2, 2);
	}while (W >= 1 || W == 0);

	mult = sqrt ((-2 * log (W)) / W);
	X1 = U1 * mult;
	X2 = U2 * mult;
	call = !call;
	return (mu + sigma * (double) X1);
}

double f_x(double x){
	return sin(0.02 * x) + sin(0.001 * x) + 0.1 * randn(0, 1);
}

double timeDiff(struct timespec tStart,struct timespec tEnd){
   struct timespec diff;

   diff.tv_sec=tEnd.tv_sec-tStart.tv_sec-(tEnd.tv_nsec<tStart.tv_nsec?1:0);
   diff.tv_nsec=tEnd.tv_nsec-tStart.tv_nsec+(tEnd.tv_nsec<tStart.tv_nsec?1000000000:0);
   return ((double) diff.tv_sec)+((double) diff.tv_nsec)/1e9;
}

void main(){
	double x[N];
	double y[N];
	double yest[N];
	int i,j;
	double sumA, sumB;
	struct timespec timeVect[2];
    double timeCPU;
	FILE* fp;
	
	for(i=0;i<N;i++){
		x[i]=(i*1.0)/10;
		y[i]=f_x(x[i]);
	}
	
	clock_gettime(CLOCK_REALTIME, &timeVect[0]);
	for(i=0;i<N;i++){
		sumA=0;
		sumB=0;
		for(j=0;j<N;j++){
			sumA = sumA + exp((-pow((x[i]-x[j]),2))/(2*pow(smooth,2)))*y[j];
			sumB = sumB + exp((-pow((x[i]-x[j]),2))/(2*pow(smooth,2)));
		}
		yest[i] = sumA / sumB;
	}
	clock_gettime(CLOCK_REALTIME, &timeVect[1]);
	timeCPU = timeDiff(timeVect[0],timeVect[1]);
	printf("CPU execution took %.6f seconds\n", timeCPU );
	
	fp=fopen("output.csv", "w");
	fwrite("X,Y,Yest\n",9,sizeof(char),fp);
	for(i=0;i<N;i++){
	    fprintf(fp,"%f,%f,%f\n", x[i], y[i], yest[i]);
	}
	fclose(fp);
}