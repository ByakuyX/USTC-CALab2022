#include <stdio.h>
#include <stdlib.h>
using namespace std;
#define BLOCK_SIZE 8

int N;

__global__ void gemm_baseline(float *A, float *B, float *C, int N)
{
    float c0 = 0;
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < N && j < N)
    {
        for(int k = 0; k < N; k ++)
            c0 += A[i * N + k] * B[k * N + j];
        C[i * N + j] = c0;
    }
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
