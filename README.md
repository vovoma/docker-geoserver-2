# docker-geoserver
Dockerfile and supporting scripts for building a docker container served by Tomcat. For PostgreSQL database support, a separate container or server should be spun up to house it, and it should be then configured to accept connections from the docker-geoserver container.

## Getting Started
There are two ways to use the GeoServer Docker container.
1. Cloning this repo and building/running the container using run.sh (See Using the GitHub Project)
2. Pulling the image directly and using the `docker run` to run the container (See Using the Docker container)

## Pre-built environment and run.sh
First clone the project, `git clone https://github.com/brian-dlee/docker-geoserver.git`

### Environment
Cloning the repo provides two directories to serve as mount points to the GeoSever container. The two directories included are the data directory, which is intended to be mounted to /var/lib/geoserver/data and the logs directory, which is intended to be mounted to /var/log/tomcat. The data mount will contain all data for the GeoServer as well as all configuration parameters such as users, settings, and application objects. The logs directory will contain all the Tomcat and GeoServer logs.

### Executing run.sh
By default run.sh will mount the two aforementioned host directories to the container, forward the docker hosts port 80 to the container port 8080, and run the container as a daemon.

To configure this further, see the help output of run.sh (`run.sh --help`).

## Manually using the GeoServer Docker container
Pull the container from hub.docker.com: `docker pull briandlee/geoserver@2.7`

### Running the container
To run the docker container with basic configuration: `docker run -P -d briandlee/geoserver@2.7`

The container can be further configured using the following options. Options go after `run`, but before the image designation. `docker run [options] -d briandlee/geoserver@2.7`

#### Network Configuration
Below are the possible options for configuring the host and container's network mapping (these are mutually exclusive).
* Auto host port to container mapping: `-P`
* Customizing host to container port mapping: `-p HOSTPORT:8080`

#### Mount Configuration
Any directory can be mounted between the host and docker container. Below are two useful mount points for this docker container.
*Note: Without mounting the data directory, the changes made using the docker container will not persist when the docker container is destroyed.*
* Mounting the geoserver data directory: `-v SOURCE_DIRECTORY:/var/lib/geoserver/data`
* Mounting the tomcat log directory: `-v SOURCE_DIRECTORY:/var/log/tomcat`

## Accessing the GeoServer docker container:
* Getting your docker container's IP address: `docker-machine ip default`
  * *Note: If you're not using the default docker machine, use `docker-machine active` to get a list of active docker machine[s]*
* Enter your docker machine's IP address in a web browser.
