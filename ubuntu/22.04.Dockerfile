FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    software-properties-common \
    build-essential \
    apt-transport-https \
    unzip \
    sudo \
    locales \
    iputils-ping \
    git \
    curl \
    wget \
    sysstat \
    libssl-dev \
    make \
    automake \
    autoconf \
    libncurses5-dev \
    gcc \
    xsltproc \
    fop \
    libxml2-utils \
    libwxgtk3.0-gtk3-dev \
    unixodbc \
    unixodbc-dev \
    m4 \
    default-jdk \
    tzdata \
    net-tools

RUN locale-gen en_US en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# C++ 17 support for enable JIT
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y  \
    && apt-get update -y \
    && apt-get install gcc-9 g++-9 -y \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9

# beautify terminal
RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh \
    && chmod +x /usr/local/bin/oh-my-posh \
    && mkdir /root/.poshthemes \
    && wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O /root/.poshthemes/themes.zip \
    && unzip /root/.poshthemes/themes.zip -d /root/.poshthemes \
    && chmod u+rw /root/.poshthemes/*.omp.* \
    && rm /root/.poshthemes/themes.zip \
    && echo 'eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/emodipt-extend.omp.json)"' >> /root/.bashrc
# Remember install fonts
# oh-my-posh font install

RUN echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | sudo tee /etc/apt/sources.list.d/versionfox.list \
   && apt-get update \
   && apt-get install -y vfox

ENV ERLANG_VERSION=26.2.5
ENV ELIXIR_VERSION=1.16.2
ENV MAKEFLAGS=-j8
RUN vfox add erlang \
    && vfox add elixir \
    && vfox install erlang@${ERLANG_VERSION} \
    && vfox use -g erlang@${ERLANG_VERSION} \
    && eval "$(vfox activate bash)" \
    && vfox install elixir@${ELIXIR_VERSION}

RUN echo 'root:EnjoyLife' | chpasswd
