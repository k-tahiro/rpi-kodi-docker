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
RUN sudo apt-get install git-core -y && \
    cd $HOME && \
    git clone git://github.com/xbmc/xbmc.git && \
    sudo apt-get update && \
    sudo apt-get build-dep Kodi && \
    cd $HOME/xbmc && \
    ./bootstrap && \
    ./configure && \
    make && \
    sudo make install

# post process
ENTRYPOINT Kodi
