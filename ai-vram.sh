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
        INT8)
            bytes_per_param=1
            ;;
        *)
            echo "Quantização inválida. Use FP32, FP16, BF16, FP8 ou INT8."
            exit 1
            ;;
    esac

    local vram_bytes=$((params * bytes_per_param))
    local vram_gb=$(printf "%.2f" $(echo "scale=2; $vram_bytes / 1024 / 1024 / 1024" | bc))

    echo "Parâmetros: $params"
    echo "Quantização: $quant"
    echo "VRAM necessária: $vram_gb GB"
}

read -p "Digite os números de parâmetros (separados por espaço): " param_list
read -p "Digite os tipos de quantização (separados por espaço): " quant_list

IFS=' ' read -ra params <<< "$param_list"
IFS=' ' read -ra quants <<< "$quant_list"

if [ ${#params[@]} -ne ${#quants[@]} ]; then
    echo "O número de parâmetros deve ser igual ao número de tipos de quantização."
    exit 1
fi

for i in "${!params[@]}"; do
    calculate_vram $((${params[i]} * 1000000000)) ${quants[i]}
done
