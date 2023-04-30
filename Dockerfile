FROM ubuntu
LABEL OMEGA build container
ARG USERHOME=/home/workspace/omega_home
ARG USERSOURCE=${USERHOME}/source

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    cpio \
    git \
    gzip \
    locales \
    libncurses5-dev \
    libdevmapper-dev \
    libsystemd-dev \
    make \
    mercurial \
    whois \
    patch \
    perl \
    python3 \
    rsync \
    sed \
    tar \
    vim \ 
    unzip \
    wget \
    bison \
    flex \
    libssl-dev \
    libfdt-dev \
    file \
    python2 \
    subversion \
    zlib1g-dev gawk flex quilt time \
    libpam-modules libldap-common libidn2-0 libssh2-1-dev liblzma-dev libsnmp-dev libgnutls28-dev

RUN mkdir -p  /install_g++-4.8
WORKDIR /install_g++-4.8
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/g++-4.8_4.8.5-4ubuntu8_amd64.deb 
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/libstdc++-4.8-dev_4.8.5-4ubuntu8_amd64.deb 
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/gcc-4.8-base_4.8.5-4ubuntu8_amd64.deb 
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/gcc-4.8_4.8.5-4ubuntu8_amd64.deb 
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/libgcc-4.8-dev_4.8.5-4ubuntu8_amd64.deb 
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/cpp-4.8_4.8.5-4ubuntu8_amd64.deb 
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/libasan0_4.8.5-4ubuntu8_amd64.deb  
RUN apt install ./gcc-4.8_4.8.5-4ubuntu8_amd64.deb ./gcc-4.8-base_4.8.5-4ubuntu8_amd64.deb ./libstdc++-4.8-dev_4.8.5-4ubuntu8_amd64.deb ./cpp-4.8_4.8.5-4ubuntu8_amd64.deb ./libgcc-4.8-dev_4.8.5-4ubuntu8_amd64.deb ./libasan0_4.8.5-4ubuntu8_amd64.deb ./g++-4.8_4.8.5-4ubuntu8_amd64.deb

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
RUN update-alternatives --set cc /usr/bin/gcc

RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
RUN update-alternatives --set c++ /usr/bin/g++

# check gcc and g++ version
RUN gcc --version


ARG USER_ID=1000
ARG GROUP_ID=1000

RUN mkdir -p ${USERHOME}

RUN groupadd -g $GROUP_ID omega_root
RUN useradd -u $USER_ID -g $GROUP_ID -s /bin/bash -d ${USERHOME} omega
RUN chown -R ${GROUP_ID}:${USER_ID} ${USERHOME}
COPY --chown=${USER_ID}:${USER_ID} *.patch ${USERHOME}
COPY --chown=${USER_ID}:${USER_ID} config ${USERHOME}

USER omega

WORKDIR ${USERHOME}
RUN git clone https://github.com/OnionIoT/source.git
WORKDIR ${USERSOURCE}
# start config process
# Set SDK environment for Omega2
# For Omega2+ change the third echo line with: (notice the 'p' for plus)
#  echo "CONFIG_TARGET_ramips_mt7688_DEVICE_omega2p=y" > .config && \
RUN pwd
RUN git apply --whitespace=warn ../*.patch
RUN cp ../config ./.config
RUN make
#RUN sudo make install



# start build process
