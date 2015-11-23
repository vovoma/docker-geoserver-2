# docker-geoserver
Dockerfile and supporting scripts for building a docker container served by Tomcat. For PostgreSQL database support, a separate container or server should be spun up to house it, and it should be then configured to accept connections from the docker-geoserver container.

Getting the container: `docker pull briandlee/geoserver@2.7`

### Configuring the container

#### Network Configuration
* Auto host port selection: `-P`
* Customizing host to container port mapping: `-p HOSTPORT:8080`

#### Mount Configuration
* Mounting the geoserver data directory: `-v SOURCE_DIRECTORY:/var/lib/geoserver/data`
* Mounting the geoserver application directory: `-v SOURCE_DIRECTORY:/var/lib/tomcat/webapps/geoserver`
* Mounting the tomcat log directory: `-v SOURCE_DIRECTORY:/var/log/tomcat`

### Running container:
Run: `docker run [PORT_CONFIG] [VOLUME_CONFIG ...] -d briandlee/geoserver@2.7`

### Accessing the GeoServer docker container:
* Getting your docker container's IP address: `docker-machine ip default`
  * *Note: If you're not using the default docker machine, use `docker-machine active` to get a list of active docker machine[s]*
* Enter your docker machine's IP address in a web browser.

Without mounting the data directory, the changes made using the docker container will not persist when the docker container is destroyed.
