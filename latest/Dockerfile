FROM ubuntu:14.04

# Install dev environment
RUN apt-get update && apt-get install -y \
  ack-grep \
  autoconf \
  bash-completion \
  bindfs \
  build-essential \
  cmake \
  cmake \
  curl \
  diffstat \
  g++ \
  gcovr \
  git \
  lcov \
  libboost-date-time-dev \
  libboost-dev \
  libboost-filesystem-dev \
  libboost-regex-dev \
  libboost-signals-dev \
  libboost-test-dev \
  libboost-thread-dev \
  libevent-dev \
  libprotobuf-dev \
  libssl-dev \
  libtool \
  libyaml-cpp-dev \
  libzmq3-dev \
  pkg-config \
  pkg-config \
  protobuf-compiler \
  python \
  python-pip \
  screen \
  strace \
  tcpdump \
  unzip \
  vim \
  wget

# Install the julia and the julia protobuf plugin
RUN wget -O - "https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.0-linux-x86_64.tar.gz" | tar zxvf - -C /opt
RUN ln -s /opt/julia-3c9d75391c/bin/julia /usr/bin/julia
RUN julia -e 'Pkg.update(); Pkg.add("ProtoBuf")'

# Setup home environment
RUN useradd steve
RUN gpasswd -a steve fuse
RUN mkdir /home/steve && chown -R steve: /home/steve

# Copy the .julia from /root to /home/steve
RUN cp -R /root/.julia /home/steve/.julia

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/
RUN touch /var/shared/placeholder
RUN chown -R steve:steve /var/shared
VOLUME /var/shared

ENV PATH $PATH:/home/steve/.julia/v0.5/ProtoBuf/plugin

WORKDIR /home/steve
ENV HOME /home/steve

# Add the git bash prompt
RUN git clone https://github.com/arialdomartini/oh-my-git.git /home/steve/.oh-my-git
RUN echo '\
source /home/steve/.oh-my-git/prompt.sh
' >> /home/steve/.bashrc

# Add python virtualenvwrapper
RUN pip install virtualenvwrapper
RUN ln -s /usr/local/bin/virtualenvwrapper.sh /usr/bin/virtualenvwrapper.sh
RUN bash -c "source /usr/local/bin/virtualenvwrapper.sh"

RUN echo '\
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/devel
source /usr/local/bin/virtualenvwrapper.sh
' >> /home/steve/.bashrc

# Link in shared parts of the home directory
RUN ln -s /var/shared/.vimrc /home/steve/.vimrc
RUN ln -s /var/shared/.vim /home/steve/.vim
RUN ln -s /var/shared/.gitconfig /home/steve/.gitconfig
RUN ln -s /var/shared/.ssh /home/steve/.ssh
RUN ln -s /var/shared/.bash_history /home/steve/.bash_history
RUN ln -s /var/shared/devel /home/steve/devel

# Pretty bash prompt
RUN echo 'export PS1="\[\033[36m\][\[\033[m\]\[\033[33m\]\u@\h\[\033[m\] \[\033[32m\]\W\[\033[m\]\[\033[36m\]]\[\033[m\] $ "' >> /home/steve/.bashrc

# Add in bash completion
RUN echo '\
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then\n\
    . /etc/bash_completion\n\
fi\n\
' >> /home/steve/.bashrc

RUN echo user_allow_other >> /etc/fuse.conf

RUN chown -R steve: /home/steve
USER steve

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
