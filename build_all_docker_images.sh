#!/bin/sh

mkdir docker_build_logs                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                
#                                                                                                                                                                                                                                                                               
# CPU                                                                                                                                                                                                                                                                           
#                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                
echo 'Default cpu build'                                                                                                                                                                                                                                                        
date                                                                                                                                                                                                                                                                            
docker build -t jolibrain/deepdetect_cpu_optimized \                                                                                                                                                                                                                            
  --no-cache \                                                                                                                                                                                                                                                                  
  -f cpu.Dockerfile \                                                                                                                                                                                                                                                           
  . > docker_build_logs/deepdetect_cpu_optimized.log                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                
docker build -t jolibrain/deepdetect_cpu_optimized_nomodels \                                                                                                                                                                                                                   
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \                                                                                                                                                                                                                                 
  --no-cache \                                                                                                                                                                                                                                                                  
  -f cpu.Dockerfile \                                                                                                                                                                                                                                                           
  . > docker_build_logs/deepdetect_cpu_optimized_nomodels.log                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                
echo 'caffe-tf cpu build'                                                                                                                                                                                                                                                       
date                                                                                                                                                                                                                                                                            
docker build -t jolibrain/deepdetect_cpu_optimized_caffe-tf \                                                                                                                                                                                                                   
  --build-arg DEEPDETECT_BUILD=caffe-tf \                                                                                                                                                                                                                                       
  --no-cache \                                                                                                                                                                                                                                                                  
  -f cpu.Dockerfile \                                                                                                                                                                                                                                                           
  . > docker_build_logs/deepdetect_cpu_caffe-tf_optimized.log                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                
docker build -t jolibrain/deepdetect_cpu_optimized_caffe-tf_nomodels \                                                                                                                                                                                                          
  --build-arg DEEPDETECT_BUILD=caffe-tf \                                                                                                                                                                                                                                       
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \                                                                                                                                                                                                                                 
  --no-cache \                                                                                                                                                                                                                                                                  
  -f cpu.Dockerfile \                                                                                                                                                                                                                                                           
  . > docker_build_logs/deepdetect_cpu_optimized_caffe-tf_nomodels.log                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                
echo 'armv7 cpu build'                                                                                                                                                                                                                                                          
date                                                                                                                                                                                                                                                                            
docker build -t jolibrain/deepdetect_cpu_optimized_armv7 \
  --build-arg DEEPDETECT_BUILD=armv7 \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu_armv7_optimized.log

docker build -t jolibrain/deepdetect_cpu_optimized_armv7_nomodels \
  --build-arg DEEPDETECT_BUILD=armv7 \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f cpu.Dockerfile \
  . > docker_build_logs/deepdetect_cpu_optimized_armv7_nomodels.log

#
# GPU - CUDA 9
# 
  
echo 'Default gpu build'
date
docker build -t jolibrain/deepdetect_gpu_optimized \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized.log
  
docker build -t jolibrain/deepdetect_gpu_optimized_nomodels \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_nomodels.log

docker build -t jolibrain/deepdetect_gpu_optimized_nomodels \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_nomodels.log

echo 'caffe-tf gpu build'
date
docker build -t jolibrain/deepdetect_gpu_optimized_caffe-tf \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_caffe-tf.log

docker build -t jolibrain/deepdetect_gpu_optimized_caffe-tf_nomodels \
  --build-arg DEEPDETECT_BUILD=caffe-tf \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_caffe-tf_nomodels.log

echo 'caffe2 gpu build'
date
docker build -t jolibrain/deepdetect_gpu_optimized_caffe2 \
  --build-arg DEEPDETECT_BUILD=caffe2 \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_caffe2.log

docker build -t jolibrain/deepdetect_gpu_optimized_caffe2_nomodels \
  --build-arg DEEPDETECT_BUILD=caffe2 \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_caffe2_nomodels.log

echo 'p100 gpu build'
date
docker build -t jolibrain/deepdetect_gpu_optimized_p100 \
  --build-arg DEEPDETECT_BUILD=p100 \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_p100.log

docker build -t jolibrain/deepdetect_gpu_optimized_p100_nomodels \
  --build-arg DEEPDETECT_BUILD=p100 \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_p100_nomodels.log
  
echo 'volta gpu build'
date
docker build -t jolibrain/deepdetect_gpu_optimized_volta \
  --build-arg DEEPDETECT_BUILD=volta \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_volta.log

docker build -t jolibrain/deepdetect_gpu_optimized_volta_nomodels \
  --build-arg DEEPDETECT_BUILD=volta \
  --build-arg DEEPDETECT_DEFAULT_MODELS=false \
  --no-cache \
  -f gpu.Dockerfile \
  . > docker_build_logs/deepdetect_gpu_optimized_volta_nomodels.log
