FROM openjdk:8-slim-buster

ARG POLYNOTE_VERSION="0.4.2"
ARG SCALA_VERSION="2.12"
ARG DIST_TAR="polynote-dist.tar.gz"
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PY_VER=3.7

WORKDIR /opt

RUN apt update -y
RUN apt install -y wget python3 python3-dev python3-pip build-essential curl
RUN pip3 install --upgrade pip

RUN wget -q https://github.com/polynote/polynote/releases/download/$POLYNOTE_VERSION/$DIST_TAR

RUN tar xfzp $DIST_TAR

RUN echo "DIST_TAR=$DIST_TAR"

RUN rm $DIST_TAR

RUN pip3 install -r ./polynote/requirements.txt

COPY ext_requirements.txt ./
RUN pip3 install -r ext_requirements.txt

WORKDIR /opt/spark/work-dir
RUN wget https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz
RUN tar -xvf spark-3.1.1-bin-hadoop3.2.tgz
RUN mv spark-3.1.1-bin-hadoop3.2/* /opt/spark

WORKDIR /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYSPARK_PYTHON=python3

WORKDIR /opt/

ENV UID 1000
ENV NB_USER docker_user

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${UID} \
    ${NB_USER}

RUN chown -R ${NB_USER}:${NB_USER} /opt/

USER ${NB_USER}

COPY config.yml ./polynote/config.yml

EXPOSE 8192

ENV POLYNOTE_SCALA_VERSION ${SCALA_VERSION}

ENTRYPOINT ["python3"]
CMD ["./polynote/polynote.py"]
