//
// Created by gabrielsousa on 20/12/2025.
//

#include "main.h"


#include <iostream>
#include <optional>
#include <tuple>

// Função simulando inferência que pode falhar (std::optional é C++17)
std::optional<float> inference_mock(bool success) {
    if (success) return 0.95f;
    return std::nullopt;
}

std::tuple<int, int> get_tensor_shape() {
    return {1024, 768};
}

int main() {
    // Structured Binding (C++17) - Extrai valores da tupla diretamente
    auto [width, height] = get_tensor_shape();

    std::cout << "Tensor Shape: " << width << "x" << height << std::endl;

    auto result = inference_mock(true);
    if (result) {
        std::cout << "Inference Score: " << *result << std::endl;
    }

    return 0;
}