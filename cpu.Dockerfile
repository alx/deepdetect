FROM ubuntu:16.04 AS build

ARG DEEPDETECT_ARCH=cpu
ARG DEEPDETECT_BUILD=default

# Add gcc7 repository
RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y

# Install build dependencies
RUN apt-get update -y && \
    apt-get install -y git \
    cmake \
    automake \
    build-essential \
    openjdk-8-jdk \
    pkg-config \
    zip \
    g++ \
    gcc-7 g++-7 \
    zlib1g-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libeigen3-dev \
    libopencv-dev \
    libcppnetlib-dev \
    libboost-dev \
    libboost-iostreams-dev \
    libcurlpp-dev \
    libcurl4-openssl-dev \
    protobuf-compiler \
    libopenblas-dev \
    libhdf5-dev \
    libprotobuf-dev \
    libleveldb-dev \
    libsnappy-dev \
    liblmdb-dev \
    libutfcpp-dev \
    wget \
    autoconf \
    libtool-bin \
    python-numpy \
    python-future \
    swig \
    curl \
    unzip \
    libspdlog-dev \
    python-setuptools \
    python-dev \
    python-wheel \
    unzip \
    libgoogle-perftools-dev \
    libarchive-dev \
    bash-completion && \
    wget -O /tmp/bazel.deb https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel_0.24.1-linux-x86_64.deb && \
    dpkg -i /tmp/bazel.deb && \
    apt-get remove -y libcurlpp0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt
RUN git clone https://github.com/jpbarrette/curlpp.git
WORKDIR /opt/curlpp
RUN cmake . && \
    make install && \
    cp /usr/local/lib/libcurlpp.* /usr/lib/

WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0.tar.gz
RUN tar xvzf cmake-3.14.0.tar.gz
WORKDIR /opt/cmake-3.14.0
RUN ./bootstrap && \
    make && \
    make install

# Build Deepdetect
ADD ./ /opt/deepdetect
WORKDIR /opt/deepdetect/build
RUN ./build.sh
# Copy libs to /tmp/libs for next build stage
RUN ./get_libs.sh

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
    apt-get install -y wget \
	libopenblas-base \
	liblmdb0 \
	libleveldb1v5 \
	libboost-regex1.58.0 \
	libgoogle-glog0v5 \
	libopencv-highgui2.4v5 \
	libcppnetlib0 \
	libgflags2v5 \
	libcurl3 \
	libhdf5-cpp-11 \
	libboost-filesystem1.58.0 \
	libboost-thread1.58.0 \
	libboost-iostreams1.58.0 \
	libarchive13 \
	libprotobuf9v5 && \
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
COPY --from=build /tmp/lib/* /usr/lib/

WORKDIR /opt/deepdetect/build/main
VOLUME ["/data"]

# Set entrypoint
CMD ./dede -host 0.0.0.0
EXPOSE 8080