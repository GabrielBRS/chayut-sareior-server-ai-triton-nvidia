cmake_minimum_required(VERSION 3.20)

# AQUI ESTÁ A MÁGICA: Adicionamos "CUDA" na lista de linguagens
project(chayut-sareior-server-ai-triton-nvidia LANGUAGES CXX CUDA)

# Define o padrão C++17 para o Host (CPU) - Obrigatório para Triton
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Define o padrão C++17 também para o Device (GPU)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

# Diz para o CMake que o executável nasce do arquivo .cu
add_executable(chayut-sareior-server-ai-triton-nvidia main.cu)