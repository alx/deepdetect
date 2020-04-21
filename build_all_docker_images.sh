#!/bin/sh

# Set deepdetect version tags
DOCKER_TAG="pre"

# Set to true if you want to push images to dockerhub
PUSH_DOCKERHUB=false
# PUSH_DOCKERHUB=true

mkdir docker_build_logs

#
# CPU
#

echo 'Default cpu build'
date
docker build -t jolibrain/deepdetect_cpu:$DOCKER_TAG \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_cpu:$DOCKER_TAG
fi

echo 'cpu_tf build'
date
docker build -t jolibrain/deepdetect_cpu_tf:$DOCKER_TAG \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu_tf.log


if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_cpu_tf:$DOCKER_TAGS
fi

#
# GPU
#

echo 'Default gpu build'
date
docker build -t jolibrain/deepdetect_gpu:$DOCKER_TAG \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu:$DOCKER_TAG
fi

echo 'gpu_tf_cpu build'
date
docker build -t jolibrain/deepdetect_gpu_tf_cpu:$DOCKER_TAG \
  --build-arg DEEPDETECT_BUILD=caffe-cpu-tf \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_tf_cpu.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu_tf_cpu:$DOCKER_TAG
fi

echo 'gpu_faiss build'
date
docker build -t jolibrain/deepdetect_gpu_faiss:$DOCKER_TAG \
  --build-arg DEEPDETECT_BUILD=faiss \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_faiss.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu_faiss:$DOCKER_TAG
fi

echo 'gpu_pytorch build'
date
docker build -t jolibrain/deepdetect_gpu_pytorch:$DOCKER_TAG \
  --build-arg DEEPDETECT_BUILD=pytorch \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_pytorch.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu_tf_cpu:$DOCKER_TAG
fi

# deepdetect_gpu_caffe2

## TODO: build this one on armv7 hardware
##
## echo 'ncnn_pi3 build'
## date
## docker build -t jolibrain/deepdetect_ncnn_pi3:$DOCKER_TAG \
##   --build-arg DEEPDETECT_BUILD=armv7 \
##   --no-cache \
##   -f cpu-armv7.Dockerfile \
##   . > docker_build_logs/deepdetect_ncnn_pi3.log
##
## docker build -t jolibrain/deepdetect_ncnn_pi3:$TAG_NOMODELS \
##   --build-arg DEEPDETECT_BUILD=armv7 \
##   --build-arg DEEPDETECT_DEFAULT_MODELS=false \
##   --no-cache \
##   -f cpu-armv7.Dockerfile \
##   . > docker_build_logs/deepdetect_ncnn_pi3_nomodels.log
##
## if [ "$PUSH_DOCKERHUB" = true ] ; then
##   docker push jolibrain/deepdetect_ncnn_pi3:$DOCKER_TAG
##   docker push jolibrain/deepdetect_ncnn_pi3:$TAG_NOMODELS
## fi
##
## TODO: fix, current build not working
##
## echo 'caffe2 gpu build'
## date
## docker build -t jolibrain/deepdetect_gpu_caffe2:$DOCKER_TAG \
##   --build-arg DEEPDETECT_BUILD=caffe2 \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_caffe2.log
##
## docker build -t jolibrain/deepdetect_gpu_caffe2:$TAG_NOMODELS \
##   --build-arg DEEPDETECT_BUILD=caffe2 \
##   --build-arg DEEPDETECT_DEFAULT_MODELS=false \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_caffe2_nomodels.log
##
## if [ "$PUSH_DOCKERHUB" = true ] ; then
##   docker push jolibrain/deepdetect_gpu_caffe2:$DOCKER_TAG
##   docker push jolibrain/deepdetect_gpu_caffe2:$TAG_NOMODELS
## fi
## TODO: deploy these configurations
##
## echo 'gpu_xavier build'
## date
## docker build -t jolibrain/deepdetect_gpu_xavier:$DOCKER_TAG \
##   --build-arg DEEPDETECT_BUILD=volta \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_xavier.log
##
## docker build -t jolibrain/deepdetect_gpu_xavier:$TAG_NOMODELS \
##   --build-arg DEEPDETECT_BUILD=volta \
##   --build-arg DEEPDETECT_DEFAULT_MODELS=false \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_xavier_nomodels.log
##
## if [ "$PUSH_DOCKERHUB" = true ] ; then
##   docker push jolibrain/deepdetect_gpu_xavier:$DOCKER_TAG
##   docker push jolibrain/deepdetect_gpu_xavier:$TAG_NOMODELS
## fi
##
