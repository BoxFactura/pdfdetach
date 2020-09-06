FROM ubuntu:XX.04 as vXX

RUN apt-get update
RUN apt-get install -y sudo make
RUN apt-get install -y ruby bundler

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /app && chown -R docker /app
USER docker

WORKDIR /app
