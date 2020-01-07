# See: https://hub.docker.com/r/willmclaren/postgap/dockerfile
FROM ubuntu:16.04

RUN apt-get update && apt-get -y install build-essential curl git vim wget unzip sudo \
zlib1g-dev python2.7 python-pip autoconf dh-autoreconf pkg-config libatlas-base-dev \
libbz2-dev liblzma-dev libsqlite3-dev libcurl4-openssl-dev libgsl-dev

# create a postgap user
RUN useradd -r -m -U -d /home/postgap -s /bin/bash -c "POSTGAP User" -p '' postgap
RUN usermod -a -G sudo postgap
RUN echo "postgap     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER postgap
ENV HOME /home/postgap

# Initialize home directory
RUN mkdir -p $HOME/src
WORKDIR $HOME/src

# Clone postgap (latest commit @ TOW: c300e473a26d365ff9f892b92022c1391a52dcc5)
RUN git clone https://github.com/Ensembl/postgap.git
WORKDIR postgap

# Run install script to build various cli utilities into postgap/bin
RUN cat scripts/installation/install_dependencies.sh | \
  grep -v "pip install" > scripts/installation/install_dependencies_nopip.sh
RUN sh scripts/installation/install_dependencies_nopip.sh

# Install python packages with pinned versions
RUN pip install --user \
  pybedtools==0.7.4 \
  requests==2.22.0 \
  pandas==0.23.1 \
  numpy==1.15.4 \
  flask==1.1.1 \
  cherrypy==18.5.0 \
  h5py==2.8.0 \
  pysqlite==2.8.3

# Add commands to paths
WORKDIR $HOME
ENV PYTHONPATH $HOME/src/postgap/lib/
ENV PATH $PATH:$HOME/src/postgap/bin/
