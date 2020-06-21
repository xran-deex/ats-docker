# Dockerfile
FROM ubuntu:18.04 as builder

MAINTAINER Randy Valis "randy.valis@gmail.com"

# Do it here:
WORKDIR /src

# Install Deps
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y libgc-dev libjson-c-dev
RUN apt-get install -y curl

# Get the ATS2 and ATS2-contrib
RUN curl http://ats-lang.sourceforge.net/IMPLEMENT/Postiats/ATS2-Postiats-0.4.0.tgz -o ats2.tgz
RUN tar -xf ats2.tgz 
RUN mv ATS2-Postiats-int-0.4.0 ATS2
RUN git clone "https://github.com/githwxi/ATS-Postiats-contrib.git" ATS2-contrib

# Setup Env Vars
ENV PATSHOME="/src/ATS2"
ENV PATSCONTRIB="/src/ATS2-contrib"
ENV PATSHOMELOCS="./node_modules:./../node_modules:./../../node_modules:./../../../node_modules"
ENV PATH="${PATH}:${PATSHOME}/bin"

# Bootstrap ATS
RUN (cd ${PATSHOME} && ./configure && make all)

# For building atscc2js
RUN (cd ${PATSHOME}/contrib/CATS-atscc2js && make && mv -f bin/atscc2js ./../../bin/.)

RUN (cd ${PATSHOME} && make install)
# Confirm that ATS is properly installed
RUN which patscc
RUN which patsopt
RUN which myatscc
RUN which atscc2js
RUN apt-get update
RUN apt-get install -y npm
RUN apt-get install -y cmake

# End of [Dockerfile]
