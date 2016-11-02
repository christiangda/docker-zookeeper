# docker-zookeeper
Apache Zookeeper Docker container

# Description

# How to build it

Very basic procedure
```script
docker build --no-cache --rm --tag <your name>/zookeeper
```

Parametrized procedure
```script
docker build --no-cache --rm \
            --build-arg ZK_VERSION=3.4.9 \
            --build-arg ZK_MIRROR=http://apache.mirrors.pair.com \
            --tag <your name>/zookeeper:3.4.9 \
            --tag <your name>/zookeeper:latest
```

# How to use

Very basic procedure
```script
docker run -ti christiangda/zookeeper
```

Sharing Zookeeper data directory with your host
```script
mkdir -p /tmp/my-zk-data
docker run --rm -ti \
  -h "zk-01.develop.local" \
  -p 2181:2181 -p 2888:2888 -p 3888:3888 \
  -v /tmp/my-zk-data:/opt/zookeeper/conf \
  christiangda/zookeeper
```

Connecting to it
```script
# First get CONTAINER ID
docker ps

# Then use it here
docker exec -ti <CONTAINER ID from 'docker ps' command> /bin/bash
```

# Acknowledgment
This Docker file was builded thank you to:
* [Kevin Sookocheff and his blog](https://sookocheff.com/post/docker/containerizing-zookeeper-a-guided-tour/)
* [Justin Plock and his Docker File](https://hub.docker.com/r/jplock/zookeeper/~/dockerfile/)
