FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8
USER root

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    apt-get update && apt-get install -y wget && \
    wget https://downloads.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz && \
    tar -xvzf pig-0.17.0.tar.gz -C /opt && \
    ln -s /opt/pig-0.17.0 /opt/pig && \
    echo 'export PATH=$PATH:/opt/pig/bin' >> /root/.bashrc

ENV PIG_HOME=/opt/pig
ENV PATH=$PATH:$PIG_HOME/bin
WORKDIR /scripts
CMD ["bash"]

