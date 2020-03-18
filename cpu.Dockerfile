FROM ubuntu:16.04 AS build

ARG DEEPDETECT_ARCH=cpu
ARG DEEPDETECT_BUILD=default

# Install build dependencies
RUN apt-get update && \ 
    apt-get install -y git cmake build-essential libgoogle-glog-dev libgflags-dev libeigen3-dev libopencv-dev libcppnetlib-dev libboost-dev libboost-iostreams-dev libcurl4-openssl-dev protobuf-compiler libopenblas-dev libhdf5-dev libprotobuf-dev libleveldb-dev libsnappy-dev liblmdb-dev libutfcpp-dev wget unzip libspdlog-dev python-setuptools python-dev libarchive-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/jpbarrette/curlpp.git
WORKDIR /opt/curlpp
RUN cmake . && \
    make install && \
    cp /usr/local/lib/libcurlpp.* /usr/lib/

# Build Deepdetect
ADD ./ /opt/deepdetect
WORKDIR /opt/deepdetect/build
RUN ./build.sh

FROM ubuntu:16.04

# Download default Deepdetect models
ARG DEEPDETECT_DEFAULT_MODELS=true

# Copy Deepdetect binaries from previous step
COPY --from=build /opt/deepdetect/build/main /opt/deepdetect/build/main
COPY --from=build /opt/deepdetect/build/get_models.sh /opt/deepdetect/build/get_models.sh

LABEL maintainer="emmanuel.benazera@jolibrain.com"
LABEL description="DeepDetect deep learning server & API / CPU version"

# Install tools and dependencies
RUN apt-get update && \ 
    apt-get install -y wget libopenblas-base liblmdb0 libleveldb1v5 libboost-regex1.58.0 libgoogle-glog0v5 libopencv-highgui2.4v5 libcppnetlib0 libgflags2v5 libcurl3 libhdf5-cpp-11 libboost-filesystem1.58.0 libboost-thread1.58.0 libboost-iostreams1.58.0 libarchive13 libprotobuf9v5 && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions
RUN ln -sf /dev/stdout /var/log/deepdetect.log && \
    ln -sf /dev/stderr /var/log/deepdetect.log

RUN useradd -ms /bin/bash dd && \
    chown dd:dd /opt
USER dd

# External volume to be mapped, e.g. for models or training data
RUN mkdir /opt/models

# Include a few image models within the image
WORKDIR /opt/models
RUN /opt/deepdetect/build/get_models.sh

COPY --chown=dd --from=build /opt/deepdetect/datasets/imagenet/corresp_ilsvrc12.txt /opt/models/ggnet/corresp.txt
COPY --chown=dd --from=build /opt/deepdetect/datasets/imagenet/corresp_ilsvrc12.txt /opt/models/resnet_50/corresp.txt
COPY --chown=dd --from=build /opt/deepdetect/templates/caffe/googlenet/*prototxt /opt/models/ggnet/
COPY --chown=dd --from=build /opt/deepdetect/templates/caffe/resnet_50/*prototxt /opt/models/resnet_50/
COPY --from=build /usr/local/lib/libcurlpp.* /usr/lib/
COPY --from=build /opt/deepdetect/build/caffe_dd/src/caffe_dd/.build_release/lib/libcaffe.so.1.0.0-rc3 /usr/lib/
COPY --from=build /opt/deepdetect/build/Multicore-TSNE/src/Multicore-TSNE/multicore_tsne/build/libtsne_multicore.so /usr/lib/
COPY --from=build /opt/deepdetect/build/faiss/src/faiss/libfaiss.so /usr/lib/

WORKDIR /opt/deepdetect/build/main
VOLUME ["/data"]

# Set entrypoint
CMD ./dede -host 0.0.0.0
EXPOSE 8080