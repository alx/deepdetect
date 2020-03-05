#!/bin/bash

set -e

function cpu_build {

    case ${DEEPDETECT_BUILD} in

    "caffe-tf")
        cmake .. -DUSE_TF=ON -DUSE_TF_CPU_ONLY=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DUSE_NCNN=OFF
        make -j
        ;;

    *)
        cmake .. -DUSE_XGBOOST=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DUSE_NCNN=ON
        make -j
        ;;
    esac

}

function gpu_build {

    case ${DEEPDETECT_BUILD} in

    "caffe-cpu-tf")
        cmake .. -DUSE_TF=ON -DUSE_TF_CPU_ONLY=ON -DUSE_CUDNN=ON -DUSE_XGBOOST=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DCUDA_ARCH="-gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_61,code=sm_61"
        make
        ;;

    "caffe-tf")
        cmake .. -DUSE_TF=ON -DUSE_CUDNN=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DCUDA_ARCH="-gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_61,code=sm_61"
        make
        ;;

    "caffe2")
        cmake .. -DUSE_CUDNN=ON -DUSE_XGBOOST=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DUSE_CAFFE2=ON -DCUDA_ARCH="-gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_62,code=sm_62"
        make
        ;;

    "p100")
        cmake .. -DUSE_CUDNN=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DCUDA_ARCH="-gencode arch=compute_60,code=sm_60"
        make
        ;;

    "volta")
        cmake .. -DUSE_CUDNN=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DCUDA_ARCH="-gencode arch=compute_70,code=sm_70"
        make
        ;;

    *)
        cmake .. -DUSE_CUDNN=ON -DUSE_XGBOOST=ON -DUSE_SIMSEARCH=ON -DUSE_TSNE=ON -DCUDA_ARCH="-gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_62,code=sm_62"
        make -j
        ;;
    esac

}

# Select build profile
if [[ ${DEEPDETECT_ARCH} == "cpu" ]]; then
    cpu_build
elif [[ ${DEEPDETECT_ARCH} == "gpu" ]]; then
    gpu_build
fi
