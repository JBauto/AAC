
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <sys/time.h>

#define N 10000
#define Streams 10
#define DIMENSION 2
#define smooth  4
#define twoBB   2*smooth*smooth
float randn(float mu, float sigma);
float f_x(float x);

double timeDiff(struct timespec tStart, struct timespec tEnd){
   struct timespec diff;

   diff.tv_sec  = tEnd.tv_sec  - tStart.tv_sec  - (tEnd.tv_nsec<tStart.tv_nsec?1:0);
   diff.tv_nsec = tEnd.tv_nsec - tStart.tv_nsec + (tEnd.tv_nsec<tStart.tv_nsec?1000000000:0);

   return ((double) diff.tv_sec) + ((double) diff.tv_nsec)/1e9;
}

float randn(float mu, float sigma){
	float U1, U2, W, mult;
	static float X1, X2;
	static int call = 0;

	if (call == 1){
		call = !call;
		return (mu + sigma * (float)X2);
	}

	do{
		U1 = -1 + ((float)rand() / RAND_MAX) * 2;
		U2 = -1 + ((float)rand() / RAND_MAX) * 2;
		W = pow(U1, 2) + pow(U2, 2);
	} while (W >= 1 || W == 0);

	mult = sqrt((-2 * log(W)) / W);
	X1 = U1 * mult;
	X2 = U2 * mult;

	call = !call;

	return (mu + sigma * (float)X1);
}

float f_x(float x){
	return sin(0.02 * x) + sin(0.001 * x) + 0.1 * randn(0, 1);
}



__global__ void Kernel(float *x, float *y, float *expo, float *sumB, float *div)
{

    float twosmoothsqr = (float) 2*smooth*smooth;

    float soma1_16 = 0, soma2_16 = 0, soma3_16 = 0, soma4_16 = 0;
    float soma5_16 = 0,soma6_16 = 0,soma7_16 = 0, soma8_16 = 0;
    float soma9_16 = 0,soma10_16 = 0,soma11_16 = 0, soma12_16 = 0;
    float soma13_16 = 0,soma14_16 = 0,soma15_16 = 0, soma16_16 = 0;
    float soma = 0;
    int index_x = blockIdx.x * blockDim.x + threadIdx.x;
    int index_y = blockIdx.y * blockDim.y + threadIdx.y;
    int grid_width = gridDim.x * blockDim.x;

    int blockId = blockIdx.x + blockIdx.y  * gridDim.x; 
    int index = blockId * (blockDim.x *blockDim.y) + (threadIdx.y*blockDim.x) + threadIdx.x;

    if(index_x < N && index_y < N){
        expo[index_y + index_x * N] = exp((-pow((x[index_x]-x[index_y]),2))/twosmoothsqr);
        expo[index_y + index_x * N + N*N] = exp((-pow((x[index_x]-x[index_y]),2))/twosmoothsqr)*y[index_y];
    }
    __syncthreads();

    /*if(index < 2*N){
        for(int i = 0; i< N ; i++){
            soma += expo[i + index*N];
        }
        sumB[index] = soma;
    }*/

    if(index < 2*N){
        for(int i = 0; i< N/16 ; i++){
            soma1_16 += expo[i + index*N];        
            soma2_16 += expo[i + N/16 + index*N];        
            soma3_16 += expo[i + 2*(N/16) + index*N];        
            soma4_16 += expo[i + 3*(N/16) + index*N];        
            soma5_16 += expo[i + 4*(N/16) + index*N];        
            soma6_16 += expo[i + 5*(N/16) + index*N];        
            soma7_16 += expo[i + 6*(N/16) + index*N];        
            soma8_16 += expo[i + 7*(N/16) + index*N];        
            soma9_16 += expo[i + 8*(N/16) + index*N];        
            soma10_16 += expo[i + 9*(N/16) + index*N];        
            soma11_16 += expo[i + 10*(N/16) + index*N];        
            soma12_16 += expo[i + 11*(N/16) + index*N];        
            soma13_16 += expo[i + 12*(N/16) + index*N];        
            soma14_16 += expo[i + 13*(N/16) + index*N];        
            soma15_16 += expo[i + 14*(N/16) + index*N];        
            soma16_16 += expo[i + 15*(N/16) + index*N];        
        }
        sumB[index] = soma1_16+soma2_16+soma3_16+soma4_16+soma5_16+soma6_16+soma7_16+soma8_16+soma9_16+soma10_16+soma11_16+soma12_16+soma13_16+soma14_16+soma15_16+soma16_16;
    }
    
    __syncthreads();

    if(index < N){
        div[index] = sumB[index + N] / sumB[index];
    }

}

int main()
{

	int device;
	int maxThreadsPerBlock;
	int blocksPerGrid;
	int Xsize, Ysize, exposize, sumBsize, Divsize;
    int sharedmem;
	float x[N], y[N], expo[N], Div[N];
	float *d_X = NULL ,*d_Y = NULL,*d_expo = NULL,*d_sumA = NULL, *d_sumB = NULL,*d_Div = NULL;
    FILE *fp;
    struct timespec timeVect[20];
    double timeCPU, timeGPU[20];
    cudaError_t err[] = { cudaSuccess , cudaSuccess , cudaSuccess };
    cudaError_t mem = cudaSuccess;
    if (err[0] != cudaSuccess)
    {
        fprintf(stderr, "Failed to deinitialize the device! error=%s\n", cudaGetErrorString(err[0]));
        exit(EXIT_FAILURE);
    }
    clock_gettime(CLOCK_REALTIME, &timeVect[9]);
    cudaGetDevice(&device);
    clock_gettime(CLOCK_REALTIME, &timeVect[10]);
    cudaFree(0);

	   float sumA, sumB, yest_cpu[N];
    
    // Allocate the host
    float *h_X = (float *)malloc(N * sizeof(float));
    float *h_Y = (float *)malloc(N * sizeof(float));
    float *yest = (float *)malloc(N * sizeof(float));

    // Verify that allocations succeeded
    if (h_X == NULL || h_Y == NULL || yest == NULL )
    {
        fprintf(stderr, "Failed to allocate host data!\n");
        exit(EXIT_FAILURE);
    }

    // Initialize the host input data
    for (int i = 0; i < N ; i++ ){
        h_X[i] = (i*1.0)/10;
        h_Y[i] = f_x(h_X[i]);
        yest[i] = 1;
    }

    // Compute expected result
    printf("Performing the computation on the CPU...\n");
    clock_gettime(CLOCK_REALTIME, &timeVect[0]);
    for(int i=0;i<N;i++){
        sumA=0;
        sumB=0;
        for(int j=0;j<N;j++){
            sumA = sumA + exp((-pow((h_X[i]-h_X[j]),2))/(2*pow(smooth,2)))*h_Y[j];
            sumB = sumB + exp((-pow((h_X[i]-h_X[j]),2))/(2*pow(smooth,2)));
        }
        yest_cpu[i] = sumA / sumB;
    }
    clock_gettime(CLOCK_REALTIME, &timeVect[1]);
    timeCPU = timeDiff(timeVect[0],timeVect[1]);
	Xsize = N * sizeof(float);
	Ysize = N * sizeof(float);
    exposize = N * sizeof(float);
    sumBsize = N * sizeof(float);
    Divsize = N * sizeof(float);
	


    struct cudaDeviceProp props;
	cudaGetDeviceProperties(&props, device);
    
    size_t uCurAvailMemoryInBytes;
    size_t uTotalMemoryInBytes;
    cudaMemGetInfo( &uCurAvailMemoryInBytes, &uTotalMemoryInBytes );
    int mem_av = uTotalMemoryInBytes;
	printf("Device Number: %d\n", device);
	printf("\tDevice name: %s\n", props.name);
	printf("\tDevice max threads per block: %d\n", props.maxThreadsPerBlock);
	printf("\tMemory Clock Rate (KHz): %d\n", props.memoryClockRate);
	printf("\tMemory Bus Width (bits): %d\n",props.memoryBusWidth);
    printf("\tTotal Memory Available (MB): %d\n",uTotalMemoryInBytes / ( 1024 * 1024 ));
    printf("\tShared memory: %d\n",props.sharedMemPerBlock);

    sharedmem = props.sharedMemPerBlock;
	maxThreadsPerBlock = props.maxThreadsPerBlock;
    // create 2d 2x2 thread block
    dim3 block_size;
    block_size.x = sqrt(maxThreadsPerBlock);
    block_size.y = sqrt(maxThreadsPerBlock);
    printf("Creating thread block of %dx%d threads...\n",block_size.x,block_size.y);
    //configure 2d grid
    dim3 grid_size;
    grid_size.x = sqrt((N*N) / maxThreadsPerBlock) + 1;
    grid_size.y = sqrt((N*N) / maxThreadsPerBlock) + 1;
    printf("Creating grid of %dx%d blocks...\n",grid_size.x,grid_size.y);
    clock_gettime(CLOCK_REALTIME, &timeVect[0]);
    err[0] = cudaMalloc((void**)&d_X, Xsize);
    if (err[0] != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed X!");
        return 0;
    }
    err[0] = cudaMalloc((void**)&d_Y, Ysize);
    if (err[0] != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed Y!");
        return 0;
    }
    err[0] = cudaMalloc((void**)&d_expo,exposize*N*2);
    if (err[0] != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed expo!");
        return 0;
    }

    err[0] = cudaMalloc((void**)&d_sumB,sumBsize*2);
    if (err[0] != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed sumB!");
        return 0;
    }
    err[0] = cudaMalloc((void**)&d_Div,Divsize);
    if (err[0] != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed sumB!");
        return 0;
    }
    clock_gettime(CLOCK_REALTIME, &timeVect[1]);
    cudaMemGetInfo( &uCurAvailMemoryInBytes, &uTotalMemoryInBytes );
    int mem_curr = uCurAvailMemoryInBytes;
    int mem_all = (mem_av - mem_curr)/(1024*1024);
    printf("Allocating %d MB of memory...\n",mem_all);

    printf("Copying from CPU to GPU...\n");
    err[0] = cudaMemcpy(d_X, h_X, Xsize , cudaMemcpyHostToDevice);
    err[1] = cudaMemcpy(d_Y, h_Y, Ysize , cudaMemcpyHostToDevice);

    clock_gettime(CLOCK_REALTIME, &timeVect[2]);
    if ((err[0] != cudaSuccess) || (err[1] != cudaSuccess) || (err[2] != cudaSuccess)){
        fprintf(stderr, "Failed to allocate device values X or Y! Error codes are:\n");
        fprintf(stderr, "\t Allocation of %d Bytes for value X: %s\n", Xsize , cudaGetErrorString(err[0]) );
        fprintf(stderr, "\t Allocation of %d Bytes for value Y: %s\n", Ysize , cudaGetErrorString(err[1]) );
        fprintf(stderr, "\t Allocation of %d Bytes for value Yest: %s\n", Ysize*N , cudaGetErrorString(err[2]) );
        exit(EXIT_FAILURE);
    }
    
    clock_gettime(CLOCK_REALTIME, &timeVect[3]);
    Kernel<<<grid_size, block_size>>>(d_X,d_Y,d_expo,d_sumB,d_Div);
    clock_gettime(CLOCK_REALTIME, &timeVect[4]);

    float somaA[N], somaB[2*N];

    /*err[0] = cudaMemcpy(somaA, d_sumA, N*sizeof(float) , cudaMemcpyDeviceToHost);
    if (err[0] != cudaSuccess){
        fprintf(stderr, "Failed to copy Yest from device to host (error code %s)!\n", cudaGetErrorString(err[0]));
         exit(EXIT_FAILURE);*/
    clock_gettime(CLOCK_REALTIME, &timeVect[5]);
    err[0] = cudaMemcpy(Div, d_Div, N*sizeof(float), cudaMemcpyDeviceToHost);
    clock_gettime(CLOCK_REALTIME, &timeVect[6]);
    if (err[0] != cudaSuccess){
        fprintf(stderr, "Failed to copy Yest from device to host (error code %s)!\n", cudaGetErrorString(err[0]));
         exit(EXIT_FAILURE);
    }
    fp=fopen("output.out", "w");
    for(int j=0;j<N;j++){
        fprintf(fp,"%f\n",Div[j]);
    }
    fclose(fp);

    clock_gettime(CLOCK_REALTIME, &timeVect[7]);
    cudaFree(d_X);
    cudaFree(d_Y);
    cudaFree(d_expo);
    cudaFree(d_sumB);
    cudaFree(d_Div);
    clock_gettime(CLOCK_REALTIME, &timeVect[8]);

    timeGPU[0] = timeDiff(timeVect[0],timeVect[1]);
    timeGPU[1] = timeDiff(timeVect[1],timeVect[2]);
    timeGPU[2] = timeDiff(timeVect[3],timeVect[4]);
    timeGPU[3] = timeDiff(timeVect[5],timeVect[6]);
    timeGPU[4] = timeDiff(timeVect[7],timeVect[8]);
    timeGPU[5] = timeDiff(timeVect[0],timeVect[8]);
    timeGPU[6] = timeDiff(timeVect[9],timeVect[10]);

    printf("    ... execution took %.6f seconds (speedup=%.3f), corresponding to:\n",timeGPU[5]+timeGPU[6],timeCPU/(timeGPU[5]+timeGPU[6]));
    printf("          - first call to the device           -> %.6f seconds\n",timeGPU[6]);
    printf("          - allocation of memory on the device -> %.6f seconds\n",timeGPU[0]);
    printf("          - copying data from host to device   -> %.6f seconds\n",timeGPU[1]);
    printf("          - kernel execution on the device     -> %.6f seconds\n",timeGPU[2]);
    printf("          - copying data from device to host   -> %.6f seconds\n",timeGPU[3]);
    printf("          - freeing data on the device         -> %.6f seconds\n",timeGPU[4]);
    printf("----------------------------------------------------------------------------\n");
    
    int i=0,j=0;

    for (i = 0, j = 0; i < N; i++)
    {
        if (fabs(Div[i]-yest_cpu[i]) > 1e-3)
        {
            //fprintf(stderr, "Result verification failed at element %d => CPU returns %f while GPU returns %f\n", i, yest_cpu[i],Div[i]);
            j++;
        }
    }
    if (j>0) {
        printf("%d errors found!\n",j);
        exit(EXIT_FAILURE);
    }
    printf("Test PASSED\n");

    printf("Done\n");


    return 0;

}
