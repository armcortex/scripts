# Convert Reference: https://gist.github.com/hlorand/e5012fa315dcfe358008cf1b4611c7e0
# Docker Image Reference: https://github.com/jrottenberg/ffmpeg

# Video FPS
FPS=60
SIDE_BY_SIDE_SWITCH=true
SOURCE_FOLDER_PATH="./test"
OUTPUT_NAME="_stable"
EXT_NAME=".mp4"


for INPUT_NAME in "$SOURCE_FOLDER_PATH"/*${EXT_NAME}; do
    FILENAME=`echo "$INPUT_NAME" | cut -d '.' -f -2`
    INPUT=$FILENAME$EXT_NAME
    OUTPUT=$FILENAME$OUTPUT_NAME$EXT_NAME
    TRANSFROMS=$FILENAME"_transforms.trf"
    SIDE_BY_SIDE=$FILENAME"_side_by_side_compare"$EXT_NAME

    # CPU
    cmd_base="docker run --rm -it \
        -v $(pwd):$(pwd) -w $(pwd) \
        jrottenberg/ffmpeg:5.1-ubuntu2004 \
        -i $INPUT "

    # Step 2, analyze video
    $cmd_base -vf vidstabdetect=shakiness=10:result=$TRANSFROMS -f null -

    # Step 3, stabilize video
    $cmd_base -vf vidstabtransform=smoothing=$(($FPS/2)):zoom=5:input=$TRANSFROMS $OUTPUT

    # Step 4, generate compare video
    if [ "$SIDE_BY_SIDE_SWITCH" = true ]; then
        $cmd_base -i $OUTPUT -filter_complex "[0:v:0]pad=iw*2:ih[bg]; [bg][1:v:0]overlay=w" $SIDE_BY_SIDE
    fi

    # Clean tmp files
    rm -rf $TRANSFROMS
done


# # CPU Encode
# docker run --rm -it \
#     -v $(pwd):$(pwd) -w $(pwd) \
#     jrottenberg/ffmpeg:5.1-ubuntu2004 \
#     -i $INPUT \
#     -vcodec libx264 \
#     -acodec aac \
#     -preset slow \
#     $OUTPUT


# GPU Encode
# docker run --rm -it \
#     -v $(pwd):$(pwd) -w $(pwd) \
#     --runtime=nvidia \
#     --env NVIDIA_DISABLE_REQUIRE=1 \
#     jrottenberg/ffmpeg:5.1-nvidia2004 \
#     -i $INPUT \
#     -c:v h264_nvenc \
#     -preset slow \
#     $OUTPUT

# docker run --rm -it \
#     -v $(pwd):$(pwd) -w $(pwd) \
#     --runtime=nvidia \
#     --env NVIDIA_DISABLE_REQUIRE=1 \
#     jrottenberg/ffmpeg:5.1-nvidia2004 \
#     -hwaccel cuvid \
#     -c:v h264_cuvid \
#     -i $INPUT \
#     -vf scale_npp=-1:720 \
#     -c:v h264_nvenc \
#     -preset slow $OUTPUT


# --gpus=all \

