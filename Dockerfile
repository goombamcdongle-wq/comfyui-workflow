# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.10.0-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG CIVITAI_API_KEY=""

# download models into comfyui
RUN BACKOFFS="60 300 900 1800 3600" && for i in 1 2 3 4 5; do CIVITAI_API_KEY=$CIVITAI_API_KEY comfy model download --url 'https://civitai.com/api/download/models/235334?token=a87da007730424716c9f8e9abfbf65fd' --relative-path models/checkpoints --filename '0x7RealisticFreedom_omegaSDXL.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
