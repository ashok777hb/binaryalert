FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

# set the variables as per $(pyenv init -)
ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PATH="/opt/pyenv/shims:/opt/pyenv/bin:$PATH" \
    PYENV_ROOT="/opt/pyenv" \
    PYENV_SHELL="bash"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        libbz2-dev \
        libffi-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl1.0-dev \
        liblzma-dev \
        # libssl-dev \
        llvm \
        make \
        netbase \
        pkg-config \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
        unzip \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone -b v2.3.1 --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && pyenv install 3.6.4 \
    && pyenv global 3.6.4 \
    && find $PYENV_ROOT/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rf '{}' + \
    && find $PYENV_ROOT/versions -type f '(' -name '*.pyo' -o -name '*.exe' ')' -exec rm -f '{}' + \
    && git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin  \
    && tfenv install 1.0.10 \
    && tfenv use 1.0.10 \
    && rm -rf /tmp/*
 
WORKDIR /app

COPY requirements.txt requirements.txt 

RUN pip install --upgrade pip \
    && pip install ply==3.10 \
    && pip install -r requirements.txt \
    && pip install --upgrade requests \
    && pip install awscli
COPY . . 
 
ENTRYPOINT [ "tail" ]
 
 CMD [ "-f","/dev/null" ]