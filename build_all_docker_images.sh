#!/bin/sh

# Set deepdetect version tags
TAG_MODELS="v0.9.x-pre"
TAG_NOMODELS="v0.9.x-nomodels-pre"

# Set to true if you want to push images to dockerhub
PUSH_DOCKERHUB=false
# PUSH_DOCKERHUB=true

mkdir docker_build_logs

#
# CPU
#

echo 'Default cpu build'
date
docker build -t jolibrain/deepdetect_cpu:$TAG_MODELS \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu.log

docker build -t jolibrain/deepdetect_cpu:$TAG_NOMODELS \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_cpu:$TAG_MODELS
  docker push jolibrain/deepdetect_cpu:$TAG_NOMODELS
fi

echo 'cpu_tf build'
date
docker build -t jolibrain/deepdetect_cpu_tf:$TAG_MODELS \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu_tf.log

docker build -t jolibrain/deepdetect_cpu_tf:$TAG_NOMODELS \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu_tf_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_cpu_tf:$TAG_MODELS
  docker push jolibrain/deepdetect_cpu_tf:$TAG_NOMODELS
fi

echo 'ncnn_pi3 build'
date
docker build -t jolibrain/deepdetect_ncnn_pi3:$TAG_MODELS \
  --build-arg DEEPDETECT_BUILD=armv7 \
  --no-cache \
  -f cpu-armv7.Dockerfile \
  . > docker_build_logs/deepdetect_ncnn_pi3.log

docker build -t jolibrain/deepdetect_ncnn_pi3:$TAG_NOMODELS \
  --build-arg DEEPDETECT_BUILD=armv7 \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f cpu-armv7.Dockerfile \
  . > docker_build_logs/deepdetect_ncnn_pi3_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_ncnn_pi3:$TAG_MODELS
  docker push jolibrain/deepdetect_ncnn_pi3:$TAG_NOMODELS
fi

#
# GPU - CUDA 9
#

echo 'Default gpu build'
date
docker build -t jolibrain/deepdetect_gpu:$TAG_MODELS \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu.log

docker build -t jolibrain/deepdetect_gpu:$TAG_NOMODELS \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu:$TAG_MODELS
  docker push jolibrain/deepdetect_gpu:$TAG_NOMODELS
fi

echo 'gpu_tf build'
date
docker build -t jolibrain/deepdetect_gpu_tf:$TAG_MODELS \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_tf.log

docker build -t jolibrain/deepdetect_gpu_tf:$TAG_NOMODELS \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_tf_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu_tf:$TAG_MODELS
  docker push jolibrain/deepdetect_gpu_tf:$TAG_NOMODELS
fi

## TODO: fix, current build not working
##
## echo 'caffe2 gpu build'
## date
## docker build -t jolibrain/deepdetect_gpu_caffe2:$TAG_MODELS \
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
##   docker push jolibrain/deepdetect_gpu_caffe2:$TAG_MODELS
##   docker push jolibrain/deepdetect_gpu_caffe2:$TAG_NOMODELS
## fi

echo 'p100 gpu build'
date
docker build -t jolibrain/deepdetect_gpu_p100:$TAG_MODELS \
  --build-arg DEEPDETECT_BUILD=p100 \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_p100.log

docker build -t jolibrain/deepdetect_gpu_p100:$TAG_NOMODELS \
  --build-arg DEEPDETECT_BUILD=p100 \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_p100_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu_p100:$TAG_MODELS
  docker push jolibrain/deepdetect_gpu_p100:$TAG_NOMODELS
fi

echo 'volta gpu build'
date
docker build -t jolibrain/deepdetect_gpu_volta:$TAG_MODELS \
  --build-arg DEEPDETECT_BUILD=volta \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_volta.log

docker build -t jolibrain/deepdetect_gpu_volta:$TAG_NOMODELS \
  --build-arg DEEPDETECT_BUILD=volta \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_volta_nomodels.log

if [ "$PUSH_DOCKERHUB" = true ] ; then
  docker push jolibrain/deepdetect_gpu_volta:$TAG_MODELS
  docker push jolibrain/deepdetect_gpu_volta:$TAG_NOMODELS
fi

## TODO: deploy these configurations
##
## echo 'gpu_xavier build'
## date
## docker build -t jolibrain/deepdetect_gpu_xavier:$TAG_MODELS \
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
##   docker push jolibrain/deepdetect_gpu_xavier:$TAG_MODELS
##   docker push jolibrain/deepdetect_gpu_xavier:$TAG_NOMODELS
## fi
##
## echo 'gpu_faiss build'
## date
## docker build -t jolibrain/deepdetect_gpu_faiss:$TAG_MODELS \
##   --build-arg DEEPDETECT_BUILD=volta \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_faiss.log
##
## docker build -t jolibrain/deepdetect_gpu_faiss:$TAG_NOMODELS \
##   --build-arg DEEPDETECT_BUILD=volta \
##   --build-arg DEEPDETECT_DEFAULT_MODELS=false \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_faiss_nomodels.log
##
## if [ "$PUSH_DOCKERHUB" = true ] ; then
##   docker push jolibrain/deepdetect_gpu_faiss:$TAG_MODELS
##   docker push jolibrain/deepdetect_gpu_faiss:$TAG_NOMODELS
## fi
##
## echo 'gpu_volta_faiss build'
## date
## docker build -t jolibrain/deepdetect_gpu_volta_faiss:$TAG_MODELS \
##   --build-arg DEEPDETECT_BUILD=volta \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_volta_faiss.log
##
## docker build -t jolibrain/deepdetect_gpu_volta_faiss:$TAG_NOMODELS \
##   --build-arg DEEPDETECT_BUILD=volta \
##   --build-arg DEEPDETECT_DEFAULT_MODELS=false \
##   --no-cache \
##   -f gpu.Dockerfile \
##   . > docker_build_logs/deepdetect_gpu_volta_faiss_nomodels.log
##
## if [ "$PUSH_DOCKERHUB" = true ] ; then
##   docker push jolibrain/deepdetect_gpu_volta_faiss:$TAG_MODELS
##   docker push jolibrain/deepdetect_gpu_volta_faiss:$TAG_NOMODELS
## fi
