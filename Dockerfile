FROM openjdk:8-jre-alpine

MAINTAINER Christian González <christiangda@gmail.com>

# Arguments from docker build proccess
ARG ZK_MIRROR
ARG ZK_VERSION

# Default values
ENV ZK_VERSION ${ZK_VERSION:-3.4.9}
ENV ZK_MIRROR ${ZK_MIRROR:-http://apache.mirrors.pair.com}

# Container's Labels
LABEL Description "Apache Zookeeper docker image" \
      Vendor "Christian González" \
      Name "Apache Zookeeper" \
      Version ${VERSION}

LABEL Build "docker build --no-cache --rm \
            --build-arg ZK_VERSION=3.4.9 \
            --build-arg ZK_MIRROR=http://apache.mirrors.pair.com \
            --tag christiangda/zookeeper:3.4.9 \
            --tag christiangda/zookeeper:latest \
            --tag christiangda/zookeeper:canary ." \
      Run "docker run --rm -ti -h "zk-01.develop.local" christiangda/zookeeper" \
      Connect "docker exec -ti <container id from 'docker ps' command> /bin/bash"

# Update and install Zookeeper
RUN apk --no-cache --update add wget bash \
    && mkdir /opt \
    && wget -q -O - $ZK_MIRROR/zookeeper/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZK_VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# Environment variables
ENV container docker
ENV ZK_HOME "/opt/zookeeper"
ENV PATH $ZK_HOME/bin:$PATH

# Exposed ports
EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

ENTRYPOINT ["zkServer.sh"]
CMD ["start-foreground"]
