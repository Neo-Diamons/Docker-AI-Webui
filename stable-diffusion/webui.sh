#!/usr/bin/env bash

python_cmd="python3.10"

# Disable sentry logging
export ERROR_REPORTING=FALSE

# Pretty print
delimiter="################################################################"

printf "\n%s\n" "${delimiter}"
printf "Running on \e[1m\e[32m%s\e[0m user" "$(whoami)"
printf "\n%s\n" "${delimiter}"

# Check prerequisites
gpu_info=$(lspci 2>/dev/null | grep -E "VGA|Display")
case "$gpu_info" in
    *"Navi 1"*)
        export HSA_OVERRIDE_GFX_VERSION=10.3.0
        if [[ -z "${TORCH_COMMAND}" ]]
        then
            pyv="$(${python_cmd} -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]:02d}")')"
            # Using an old nightly compiled against rocm 5.2 for Navi1, see https://github.com/pytorch/pytorch/issues/106728#issuecomment-1749511711
            if [[ $pyv == "3.8" ]]
            then
                export TORCH_COMMAND="pip install https://download.pytorch.org/whl/nightly/rocm5.2/torch-2.0.0.dev20230209%2Brocm5.2-cp38-cp38-linux_x86_64.whl https://download.pytorch.org/whl/nightly/rocm5.2/torchvision-0.15.0.dev20230209%2Brocm5.2-cp38-cp38-linux_x86_64.whl"
            elif [[ $pyv == "3.9" ]]
            then
                export TORCH_COMMAND="pip install https://download.pytorch.org/whl/nightly/rocm5.2/torch-2.0.0.dev20230209%2Brocm5.2-cp39-cp39-linux_x86_64.whl https://download.pytorch.org/whl/nightly/rocm5.2/torchvision-0.15.0.dev20230209%2Brocm5.2-cp39-cp39-linux_x86_64.whl"
            elif [[ $pyv == "3.10" ]]
            then
                export TORCH_COMMAND="pip install https://download.pytorch.org/whl/nightly/rocm5.2/torch-2.0.0.dev20230209%2Brocm5.2-cp310-cp310-linux_x86_64.whl https://download.pytorch.org/whl/nightly/rocm5.2/torchvision-0.15.0.dev20230209%2Brocm5.2-cp310-cp310-linux_x86_64.whl"
            else
                printf "\e[1m\e[31mERROR: RX 5000 series GPUs python version must be between 3.8 and 3.10, aborting...\e[0m"
                exit 1
            fi
        fi
    ;;
    *"Navi 2"*) export HSA_OVERRIDE_GFX_VERSION=10.3.0
    ;;
    *"Navi 3"*) [[ -z "${TORCH_COMMAND}" ]] && \
         export TORCH_COMMAND="pip install torch torchvision --index-url https://download.pytorch.org/whl/nightly/rocm5.7"
    ;;
    *"Renoir"*) export HSA_OVERRIDE_GFX_VERSION=9.0.0
        printf "\n%s\n" "${delimiter}"
        printf "Experimental support for Renoir: make sure to have at least 4GB of VRAM and 10GB of RAM or enable cpu mode: --use-cpu all --no-half"
        printf "\n%s\n" "${delimiter}"
    ;;
    *)
    ;;
esac
if ! echo "$gpu_info" | grep -q "NVIDIA";
then
    if echo "$gpu_info" | grep -q "AMD" && [[ -z "${TORCH_COMMAND}" ]]
    then
	      export TORCH_COMMAND="pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.7"
    elif npu-smi info 2>/dev/null
    then
        export TORCH_COMMAND="pip install torch==2.1.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu; pip install torch_npu==2.1.0"
    fi
fi

KEEP_GOING=1
LAUNCH_SCRIPT="launch.py"
export SD_WEBUI_RESTART=tmp/restart
while [[ "$KEEP_GOING" -eq "1" ]]; do
    if [[ ! -z "${ACCELERATE}" ]] && [ ${ACCELERATE}="True" ] && [ -x "$(command -v accelerate)" ]; then
        printf "\n%s\n" "${delimiter}"
        printf "Accelerating launch.py..."
        printf "\n%s\n" "${delimiter}"
        accelerate launch --num_cpu_threads_per_process=6 "${LAUNCH_SCRIPT}" "$@"
    else
        printf "\n%s\n" "${delimiter}"
        printf "Launching launch.py..."
        printf "\n%s\n" "${delimiter}"
        "${python_cmd}" -u "${LAUNCH_SCRIPT}" "$@"
    fi

    if [[ ! -f tmp/restart ]]; then
        KEEP_GOING=0
    fi
done
