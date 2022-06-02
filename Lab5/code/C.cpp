#include <stdio.h>
#include <windows.h>
#include <stdlib.h>
#include <immintrin.h>
using namespace std;

int N, BS;

void gemm_baseline(float *A, float *B, float *C)
{
    for(int i = 0; i < N; i ++)
        for(int j = 0; j < N; j ++)
        {
            float c0 = 0;
            for(int k = 0; k < N; k ++)
                c0 += A[i + k * N] * B[k + j * N];
            C[i + j * N] = c0;
        }
    return;
}

void gemm_avx(float *A, float *B, float *C)
{
    for(int i = 0; i < N; i += 8)
        for(int j = 0; j < N; j ++)
        {
            __m256 c0 = _mm256_setzero_ps();
            for(int k = 0; k < N; k ++)
                c0 = _mm256_add_ps(c0, _mm256_mul_ps(_mm256_loadu_ps(A + i + k * N), _mm256_broadcast_ss(B + k + j * N)));
            _mm256_storeu_ps(C + i + j * N, c0);
        }
    return;
}

void do_block(float *A, float *B, float *C, int si, int sj, int sk)
{
    for(int i = si; i < si + BS; i += 8)
        for(int j = sj; j < sj + BS; j ++)
        {
            __m256 c0 = _mm256_loadu_ps(C + i + j * N);
            for(int k = sk; k < sk + BS; k ++)
                c0 = _mm256_add_ps(c0, _mm256_mul_ps(_mm256_loadu_ps(A + i + k * N), _mm256_broadcast_ss(B + k + j * N)));
            _mm256_storeu_ps(C + i + j * N, c0);
        }
    return;
}
void gemm_avx_block(float *A, float *B, float *C)
{
    for(int si = 0; si < N; si += BS)
        for(int sj = 0; sj < N; sj += BS)
            for(int sk = 0; sk < N; sk += BS)
                do_block(A, B, C, si, sj, sk);
    return;
}

int main()
{
    scanf("%d%d", &N, &BS);
    N = (1 << N);
    BS = (1 << BS);
    LARGE_INTEGER t1, t2, tc;
    QueryPerformanceFrequency(&tc);
    float *A = (float *)malloc(N * N * sizeof(float));
    float *B = (float *)malloc(N * N * sizeof(float));
    float *C1 = (float *)malloc(N * N * sizeof(float));
    float *C2 = (float *)malloc(N * N * sizeof(float));
    float *C3 = (float *)malloc(N * N * sizeof(float));
    for(int i = 0; i < N * N; i ++)
    {
        A[i] = rand() / (double)RAND_MAX;
        B[i] = rand() / (double)RAND_MAX;
        C1[i] = 0;
        C2[i] = 0;
        C3[i] = 0;
    }
    QueryPerformanceCounter(&t1);
    gemm_baseline(A, B, C1);
    QueryPerformanceCounter(&t2);
    printf("Time 1: %lfs\n", ((double)(t2.QuadPart - t1.QuadPart) / tc.QuadPart));
    QueryPerformanceCounter(&t1);
    gemm_avx(A, B, C2);
    QueryPerformanceCounter(&t2);
    printf("Time 2: %lfs\n", ((double)(t2.QuadPart - t1.QuadPart) / tc.QuadPart));
    QueryPerformanceCounter(&t1);
    gemm_avx_block(A, B, C3);
    QueryPerformanceCounter(&t2);
    printf("Time 3: %lfs\n", ((double)(t2.QuadPart - t1.QuadPart) / tc.QuadPart));
    return 0;
}
