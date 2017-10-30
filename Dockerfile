FROM ubuntu:16.10
MAINTAINER nishii@yamaguchi-u.ac.jp

WORKDIR /home
RUN mkdir src

RUN apt-get update --fix-missing\
  && apt-get install -y build-essential \
  wget \
  unzip \
  bzip2 \
  cmake \
  git \
  pkg-config \
  libatlas-base-dev \
  gfortran \
  libjasper-dev \
  libgtk2.0-dev \libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  libjpeg-dev libpng-dev libtiff-dev \
  libjasper-dev libv4l-dev \
  software-properties-common \
  python-setuptools \
  tzdata

# Japanize
# https://qiita.com/tukiyo3/items/4623f130afd516571bb0
RUN apt-get install -y language-pack-ja-base language-pack-ja ibus-mozc fonts-takao
RUN ln -s -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime &&\
    dpkg-reconfigure tzdata
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
ENV LANG ja_JP.UTF-8

# clean up
RUN apt-get clean

# install anaconda
WORKDIR /home/src

RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.0-Linux-x86_64.sh
RUN bash Anaconda3-5.0.0-Linux-x86_64.sh -b -p /opt/anaconda
RUN rm Anaconda3-5.0.0-Linux-x86_64.sh
ENV PATH /opt/anaconda/bin:$PATH

RUN conda install -y \
    gcc \
    libgcc \
    ephem \
    astropy \
    pip \
    pandas \
    pillow \
    numba \
    mkl \
    theano \
    pygpu \
    opencv

# fix libstdc++ problem

RUN ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/anaconda/lib/libstdc++.so.6
RUN ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so /opt/anaconda/lib/libstdc++.so
RUN ln -sf /usr/lib/x86_64-linux-gnu/libgomp.so.1.0.0 /opt/anaconda/lib/libgomp.so
RUN ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so /opt/anaconda/lib/libstdc++.so.1

RUN conda install -y -c conda-forge ffmpeg

# Some machine learning tools
RUN conda update scikit-learn
RUN conda update conda

RUN dbus-uuidgen > /etc/machine-id

# create user pochi(uid=1000, gid=100)
ENV USER pochi
ENV HOME /home/${USER}
RUN export uid=1000 gid=100 &&\
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    install -d -m 0755 -o ${uid} -g ${gid} ${HOME}
WORKDIR ${HOME}
#RUN rmdir /home/src

# make jupyter directory
#RUN jupyter notebook --generate-config && \
#    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '*'/" /home/pochi/.jupyter/jupyter_notebook_config.py

# X
#VOLUME /tmp/.X11-unix
#VOLUME ${HOME}
#USER ${USER}

CMD [ "/bin/bash" ]
