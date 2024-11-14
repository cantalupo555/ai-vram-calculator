#!/bin/bash

calculate_vram() {
    local params=$1
    local quant=$2
    local bytes_per_param

    case $quant in
        FP32)
            bytes_per_param=4
            ;;
        FP16|BF16)
            bytes_per_param=2
            ;;
        FP8)
            bytes_per_param=1
            ;;
        *)
            echo "Quantização inválida. Use FP32, FP16, BF16 ou FP8."
            exit 1
            ;;
    esac

    local vram_bytes=$((params * bytes_per_param))
    local vram_gb=$(echo "scale=2; $vram_bytes / 1024 / 1024 / 1024" | bc)

    echo "Parâmetros: $params"
    echo "Quantização: $quant"
    echo "VRAM necessária: $vram_gb GB"
}

# Solicita entrada do usuário
read -p "Digite o número de parâmetros (em bilhões): " num_params
read -p "Digite o tipo de quantização (FP32, FP16, BF16, FP8): " quant_type

# Converte parâmetros para o número total
total_params=$((num_params * 1000000000))

# Calcula e exibe o resultado
calculate_vram $total_params $quant_type
