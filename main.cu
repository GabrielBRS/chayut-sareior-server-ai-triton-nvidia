#include <cstdlib>
#include <stdio.h>
#include <cuda_runtime.h> // Biblioteca essencial do CUDA

// --- O KERNEL (Roda na GPU) ---
// __global__ avisa que essa função roda na placa de vídeo
__global__ void somaNaGPU(const float *A, const float *B, float *C, int numElements) {
    // Cálculo mágico do ID da thread
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    // Proteção para não acessar memória fora do vetor
    if (i < numElements) {
        C[i] = A[i] + B[i];
    }
}

// --- O MAIN (Roda na CPU) ---
int main(void) {
    int n = 50000; // Vamos somar 50 mil números
    size_t size = n * sizeof(float);

    printf("[CPU] Alocando memoria...\n");

    // 1. Alocar memória na CPU (Host)
    float *h_A = (float *)malloc(size);
    float *h_B = (float *)malloc(size);
    float *h_C = (float *)malloc(size);

    // Inicializa vetores com números
    for (int i = 0; i < n; ++i) {
        h_A[i] = rand() / (float)RAND_MAX;
        h_B[i] = rand() / (float)RAND_MAX;
    }

    // 2. Alocar memória na GPU (Device)
    float *d_A, *d_B, *d_C;
    cudaMalloc((void **)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, size);

    // 3. Copiar dados da CPU -> GPU
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    // 4. Lançar o Kernel (O TIRO DE CANHÃO)
    int threadsPerBlock = 256;
    int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;

    printf("[GPU] Lancando Kernel com %d blocos de %d threads...\n", blocksPerGrid, threadsPerBlock);
    somaNaGPU<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, n);

    // Espera a GPU terminar
    cudaDeviceSynchronize();

    // 5. Copiar resultado GPU -> CPU
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Validação
    printf("[CPU] Resultado recuperado. Soma do indice 0: %f + %f = %f\n", h_A[0], h_B[0], h_C[0]);
    printf("SUCESSO: Voce acabou de rodar seu primeiro codigo CUDA!\n");

    // Limpeza (Engenharia de memória manual)
    cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
    free(h_A); free(h_B); free(h_C);

    return 0;
}