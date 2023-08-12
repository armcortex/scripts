docker run \
    -v $(pwd):$(pwd) -w $(pwd) \
    --gpus=all \
    --env NVIDIA_DISABLE_REQUIRE=1 \
    -it \
    --entrypoint /bin/bash \
    ffmpeg_cuda_11_1 \

# docker run \
#     -v $(pwd):$(pwd) -w $(pwd) \
#     --gpus=all \
#     --env NVIDIA_DISABLE_REQUIRE=1 \
#     -it \
#     --entrypoint /bin/bash \
#     jrottenberg/ffmpeg:5.1-nvidia2004 \
    

# --env NVIDIA_DISABLE_REQUIRE=1 \
# docker run --rm -it \
