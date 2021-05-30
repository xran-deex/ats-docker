# Dockerfile
FROM ubuntu:20.04 as builder

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
RUN apt-get install -y libgmp-dev

# Get the ATS2 and ATS2-contrib
RUN curl http://ats-lang.sourceforge.net/IMPLEMENT/Postiats/ATS2-Postiats-0.4.2.tgz -o ats2.tgz
RUN tar -xf ats2.tgz 
ENV PATSHOME=/opt/ats/ats2
ENV PATSCONTRIB=/opt/ats/ats2-contrib
RUN mkdir -p /opt/ats
RUN mv ATS2-Postiats-0.4.2 "${PATSHOME}"
RUN rm ats2.tgz
RUN git clone "https://github.com/githwxi/ATS-Postiats-contrib.git" "${PATSCONTRIB}"

# Setup Env Vars
ENV PATH="${PATH}:${PATSHOME}/bin"

# Bootstrap ATS
RUN (cd ${PATSHOME} && ./configure && make all)

RUN (cd ${PATSHOME} && make install)
# Confirm that ATS is properly installed
RUN which patscc
RUN which patsopt
RUN apt-get update
RUN apt-get install -y python3-minimal
RUN apt-get install -y python3-pip
RUN git clone "https://github.com/xran-deex/atsconan"
RUN pip3 install atsconan/dist/atsconan-0.1.0.tar.gz
RUN rm -r atsconan

ENV CONAN_REMOTE ""

# sets the conan remote using the CONAN_REMOTE url
COPY init.sh /bin/init.sh
RUN chmod +x /bin/init.sh

ENTRYPOINT ["/bin/init.sh"]

# End of [Dockerfile]
