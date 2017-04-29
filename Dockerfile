FROM resin/rpi-raspbian:jessie
MAINTAINER k-tahiro

# developer user creation
RUN useradd pi && \
    mkdir /home/pi && \
    chown pi:pi /home/pi && \
    echo "pi:raspberry" | chpasswd && \
    echo "pi ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

USER pi
ENV HOME=/home/pi
WORKDIR ${HOME}

# kodi installation
RUN sudo apt-get update && \
    sudo apt-get install -y git-core && \
    git clone git://github.com/xbmc/xbmc.git kodi && \
    mkdir kodi-build
WORKDIR "${HOME}/kodi-build"
RUN sudo apt-get install -y autoconf automake autopoint autotools-dev cmake curl \
                            default-jre gawk gperf libao-dev libasound2-dev \
                            libass-dev libavahi-client-dev libavahi-common-dev libbluetooth-dev \
                            libbluray-dev libbz2-dev libcap-dev \
                            libcdio-dev libcec-dev libcurl4-openssl-dev libcurl4-gnutls-dev libcurl-dev \
                            libcwiid-dev libdbus-1-dev libegl1-mesa-dev libfmt3-dev libfontconfig-dev libfreetype6-dev \
                            libfribidi-dev libgif-dev libgl1-mesa-dev libgl-dev libglu1-mesa-dev libglu-dev \
                            libiso9660-dev libjpeg-dev libltdl-dev liblzo2-dev libmicrohttpd-dev \
                            libmpcdec-dev libmysqlclient-dev libnfs-dev \
                            libpcre3-dev libplist-dev libpng12-dev libpng-dev libpulse-dev \
                            libshairplay-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev \
                            libtag1-dev libtinyxml-dev libtool libudev-dev \
                            libusb-dev libva-dev libvdpau-dev libxml2-dev \
                            libxmu-dev libxrandr-dev libxslt1-dev libxt-dev lsb-release rapidjson-dev \
                            nasm python-dev python-imaging python-support swig unzip uuid-dev yasm \
                            zip zlib1g-dev && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build . -- VERBOSE=1 && \
    sudo make install

# post process
ENTRYPOINT kodi.bin
