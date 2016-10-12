FROM debian:stable
MAINTAINER Grégoire Henry <gregoire.henry@ocamlpro.com>
WORKDIR /usr/src

RUN sed -i s/http.debian.net/ftp2.fr.debian.org/ /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
         build-essential \
         m4 \
         git \
         aspcud \
         libgmp-dev \
         libX11-dev \
         libncurses5-dev \
         binutils-dev \
         libsqlite3-dev \
         curl \
         rsync \
         ca-certificates \
         openssh-client \
         unzip \
    && rm -r /var/cache/apt \
    && rm -r /var/lib/apt/lists

ADD cache/opam /usr/local/bin/opam

ADD cache/opam-repository-init /var/cache/opam-repository

ENV OPAMROOT /opt/opam
ENV OPAMYES yes

RUN opam init /var/cache/opam-repository --comp=4.00.1
RUN opam switch install 4.01.0
RUN opam switch install 4.02.1
RUN opam switch install 4.02 --alias-of 4.02.3
RUN opam switch install 4.03 --alias-of 4.03.0+trunk

###

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
         libev-dev \
         libgdbm-dev \
         libgtk2.0-dev \
         libssl-dev \
         zlib1g-dev \
         libsvn-dev \
         libmagickcore-dev \
    && rm -r /var/cache/apt \
    && rm -r /var/lib/apt/lists

ADD cache/opam-repository.tar /var/cache/opam-repository
RUN opam update

ENV OPAMKEEPBUILDDIR yes

ADD cache/git.tar /var/cache/git
ENV GIT_ALTERNATE_OBJECT_DIRECTORIES /var/cache/git/objects

RUN git config --global user.email "dev@ocsigen.org" \
    && git config --global user.name "Ocsigen Buildbot"
#    && git config --global push.default simple ## For debian:testing

COPY ssh/ /root/.ssh/
COPY bin/ /usr/local/bin/

CMD if [ -d /usr/src/workspace ]; then /usr/local/bin/build.sh; else bash; fi
