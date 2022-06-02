#include <stdio.h>
#include <stdlib.h>
using namespace std;
#define BLOCK_SIZE 32
#define BS 32

int N;

__device__ float* GetSubMatrix(float *A, int row, int col, int N)
{
    float *Asub = A + (BS * row) * N + (BS * col);
    return Asub;
}
__device__ void SetElement(float *A, int row, int col, float val, int N)
{
    A[row * N + col] = val; 
}
__device__ float GetElement(float *A,int row, int col, int N)
{
    return A[row * N + col];
}

__global__ void gemm_baseline(float *A, float *B, float *C, int N)
{
	int block_row = blockIdx.y;
    int block_col = blockIdx.x;
    float *Csub = GetSubMatrix(C, block_row, block_col, N);
    float Cval = 0;
    int row = threadIdx.y;
    int col = threadIdx.x;
    for(int i = 0; i < N / BS; i ++)
    {
        float *Asub = GetSubMatrix(A, block_row, i, N);
        float *Bsub = GetSubMatrix(B, i, block_col, N);
        __shared__ float As[BS][BS];
        __shared__ float Bs[BS][BS];
        As[row][col] = GetElement(Asub, row, col, N);
        Bs[row][col] = GetElement(Bsub, row, col, N);
        __syncthreads();
        for(int e = 0; e < BS; e ++)
            Cval += As[row][e] * Bs[e][col];
        __syncthreads();
    }
    SetElement(Csub, row, col, Cval, N);
}

void gemm_verify(float *A, float *B, float *C)
{
    size_t size = N * N * sizeof(float);
    float *DA;
    float *DB;
    float *DC;
    cudaMalloc(&DA, size);
    cudaMalloc(&DB, size);
    cudaMalloc(&DC, size);
    cudaMemcpy(DA, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(DB, B, size, cudaMemcpyHostToDevice);
    dim3 dimBl(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGr((N + dimBl.x - 1) / dimBl.x, (N + dimBl.y - 1) / dimBl.y);
    gemm_baseline<<<dimBl, dimGr>>>(DA, DB, DC, N);
	cudaMemcpy(C, DC, size, cudaMemcpyDeviceToHost);
    cudaFree(DA);
    cudaFree(DB);
    cudaFree(DC);
}

int main()
{
    scanf("%d", &N);
    N = (1 << N);
    float *A = (float *)malloc(N * N * sizeof(float));
    float *B = (float *)malloc(N * N * sizeof(float));
    float *C = (float *)malloc(N * N * sizeof(float));
    for(int i = 0; i < N * N; i ++)
    {
        A[i] = rand() / (double)RAND_MAX;
        B[i] = rand() / (double)RAND_MAX;
        C[i] = 0;
    }
    gemm_verify(A, B, C);
    return 0;
}
