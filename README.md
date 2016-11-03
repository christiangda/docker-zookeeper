# docker-zookeeper

Apache Zookeeper Docker container

### Table of Contents

1. [Description - What the container does and why it is useful](#module-description)
2. [Setup - The basics of getting started with this docker image](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with this Container](#beginning-with-this-container)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Development - Guide for contributing to the module](#development)
7. [Authors - Who is contributing to do it](#authors)
8. [License](#license)
9. [Acknowledgment](#acknowledgment)

# Description

This Container is useful for development and testing environments, is very easy
to get running if you know about [Docker](https://www.docker.com/) and
[Apache Zookeeper](https://zookeeper.apache.org/).

If you are panning use this for Production environments, it is possible, but
you need a scheduler like [Docker Swarm](https://docs.docker.com/swarm/) or
[Kubernetes](http://kubernetes.io/).


# Setup

Is necessary install  [Docker](https://www.docker.com/) to get running this
container in your computer,  it was builded using
[Docker version 1.12.3](https://docs.docker.com/engine/installation/linux/)  on [Fedora 24 Linux](https://getfedora.org/).

## Setup requirements

Install [Docker Following this instructions](https://docs.docker.com/engine/installation/linux/)

## Beginning with this Container

To run this in your computer with default parameters, execute the Following
command
```script
docker run -ti christiangda/zookeeper
```

## Usage

If you want to run this container sharing
[ports](https://docs.docker.com/engine/reference/builder/#/expose) and
[volumes](https://docs.docker.com/engine/reference/builder/#/volume) with your local computer is possible.

Is important that you see [Apache Zookeeper configuration parameters guide](http://zookeeper.apache.org/doc/r3.4.9/zookeeperAdmin.html#sc_configuration)
to know about all possible values and parameters, this container expose the Following ports:
* 2181 (clientPort)
* 2888 (followers use to connect to the leader)
* 3888 (for leader election)

The volumes who can be exporter are:
* `/tmp/zookeeper` (dataDir)
* `/opt/zookeeper/conf` (path to configuration files)

If you want to share container's volume and its ports with your local computer, execute the following command
```script
mkdir -p /tmp/zookeeper/data
docker run --rm -ti \
  -h "zk-01.develop.local" \
  -p 2181:2181 -p 2888:2888 -p 3888:3888 \
  -v /tmp/zookeeper/data:/tmp/zookeeper \
  christiangda/zookeeper
```

If you want to share configuration files from your local computer with the container do the following:

Create a config file for logging properties
```script
cat << '__EOF__' > /tmp/zookeeper/conf/log4j.properties
# Define some default values that can be overridden by system properties
zookeeper.root.logger=INFO, CONSOLE
zookeeper.console.threshold=INFO
zookeeper.log.dir=.
zookeeper.log.file=zookeeper.log
zookeeper.log.threshold=DEBUG
zookeeper.tracelog.dir=.
zookeeper.tracelog.file=zookeeper_trace.log

# DEFAULT: console appender only
log4j.rootLogger=${zookeeper.root.logger}

#
# Log INFO level and above messages to the console
#
log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
log4j.appender.CONSOLE.Threshold=${zookeeper.console.threshold}
log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
log4j.appender.CONSOLE.layout.ConversionPattern=%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n

#
# Add ROLLINGFILE to rootLogger to get log file output
#    Log DEBUG level and above messages to a log file
log4j.appender.ROLLINGFILE=org.apache.log4j.RollingFileAppender
log4j.appender.ROLLINGFILE.Threshold=${zookeeper.log.threshold}
log4j.appender.ROLLINGFILE.File=${zookeeper.log.dir}/${zookeeper.log.file}

# Max log file size of 10MB
log4j.appender.ROLLINGFILE.MaxFileSize=10MB

log4j.appender.ROLLINGFILE.layout=org.apache.log4j.PatternLayout
log4j.appender.ROLLINGFILE.layout.ConversionPattern=%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n

#
# Add TRACEFILE to rootLogger to get log file output
#    Log DEBUG level and above messages to a log file
log4j.appender.TRACEFILE=org.apache.log4j.FileAppender
log4j.appender.TRACEFILE.Threshold=TRACE
log4j.appender.TRACEFILE.File=${zookeeper.tracelog.dir}/${zookeeper.tracelog.file}

log4j.appender.TRACEFILE.layout=org.apache.log4j.PatternLayout
### Notice we are including log4j's NDC here (%x)
log4j.appender.TRACEFILE.layout.ConversionPattern=%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L][%x] - %m%n
__EOF__
```

Create a config file for zookeeper
```script
cat << '__EOF__' > /tmp/zookeeper/conf/zoo.cfg
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/tmp/zookeeper
# the port at which the clients will connect
clientPort=2181
__EOF__
```

After that you can execute
```script
docker run --rm -ti \
  -h "zk-01.develop.local" \
  -p 2181:2181 -p 2888:2888 -p 3888:3888 \
  -v /tmp/zookeeper/conf:/opt/zookeeper/conf \
  christiangda/zookeeper
```

To get connected to the running container execute the following
```script
# First get CONTAINER ID
docker ps

# Then use it here
docker exec -ti <CONTAINER ID from 'docker ps' command> /bin/bash
```

# Development

If you want to cooperate with this project, please visit [my Github Repo](https://github.com/christiangda/docker-zookeeper)

To build this container, execute the following command
```script
docker build --no-cache --rm --tag <your name>/zookeeper
```

the parametrized procedure is
```script
docker build --no-cache --rm \
            --build-arg ZK_VERSION=3.4.9 \
            --build-arg ZK_MIRROR=http://apache.mirrors.pair.com \
            --tag <your name>/zookeeper:3.4.9 \
            --tag <your name>/zookeeper:latest
```

# Authors

[Christian González](https://github.com/christiangda)

# License

This module is released under the GNU General Public License Version 3:

* [http://www.gnu.org/licenses/gpl-3.0-standalone.html](http://www.gnu.org/licenses/gpl-3.0-standalone.html)

# Acknowledgment

This Docker file was builded thank you to:
* [Kevin Sookocheff and his blog](https://sookocheff.com/post/docker/containerizing-zookeeper-a-guided-tour/)
* [Justin Plock and his Docker File](https://hub.docker.com/r/jplock/zookeeper/~/dockerfile/)
