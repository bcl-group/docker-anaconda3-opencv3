FROM ubuntu:16.04
MAINTAINER nishii@yamaguchi-u.ac.jp

WORKDIR /home
RUN mkdir src
# RUN mkdir workspace

RUN apt-get update --fix-missing\
  && apt-get install -y build-essential \
  g++ \
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
  sudo\
  software-properties-common \
  python-setuptools

# Japanize
# https://qiita.com/tukiyo3/items/4623f130afd516571bb0
RUN apt-get install -y language-pack-ja-base language-pack-ja ibus-mozc fonts-takao
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
ENV LANG ja_JP.UTF-8

# clean up
RUN apt-get clean

# install anaconda
# Change to the src
WORKDIR /home/src

ENV ACVER 5.2.0
RUN wget https://repo.continuum.io/archive/Anaconda3-${ACVER}-Linux-x86_64.sh
RUN bash Anaconda3-${ACVER}-Linux-x86_64.sh -b -p /opt/anaconda
RUN rm Anaconda3-${ACVER}-Linux-x86_64.sh
ENV PATH /opt/anaconda/bin:$PATH

RUN conda install -y \
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

# create user (uid=1000, gid=1000)
ENV USER jovyan
ENV HOME /home/${USER}
RUN export uid=1000 gid=1000 &&\
    echo "${USER}:x:${uid}:${gid}:Developer,,,:${HOME}:/bin/bash" >> /etc/passwd &&\
    echo "${USER}:x:${uid}:" >> /etc/group &&\
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    install -d -m 0755 -o ${uid} -g ${gid} ${HOME}
WORKDIR ${HOME}

# make jupyter directory
#RUN mkdir ${HOME}/jupyter/ && \
#    jupyter notebook --generate-config && \
#    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '*'/" /home/.jupyter/jupyter_notebook_config.py

# X
ENV DISPLAY :0.0
VOLUME /tmp/.X11-unix
VOLUME ${HOME}
USER ${USER}

CMD [ "/bin/bash" ]
