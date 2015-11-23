# docker-geoserver
Dockerfile and supporting scripts for building a docker container served by Tomcat. For PostgreSQL database support, a separate container or server should be spun up to house it, and it should be then configured to accept connections from the docker-geoserver container.

Getting the container: `docker pull briandlee/geoserver@2.7`

Run the container with basic configuration: `docker run -d -P briandlee/geoserver@2.7`

Configuring the container:
Customizing port:
`-p HOSTPORT:8080`

Common volume mounts:
Mounting the geoserver data directory:
`-v SOURCE_DIRECTORY:/var/lib/geoserver/data`

Mounting the geoserver application directory:
`-v SOURCE_DIRECTORY:/var/lib/tomcat/webapps/geoserver`

Mounting the tomcat log directory:
`-v SOURCE_DIRECTORY:/var/log/tomcat`

Running with configuration options:
`docker run [PORT_CONFIG] [VOLUME_CONFIG ...] -d briandlee/geoserver@2.7`

Accessing the geoserver docker container:
Get your docker containers IP address: `docker-machine ip default`
Note: If you're not using the default docker machine, use docker-machine active to get the active docker machine[s]
Visit [docker machine ip] in a web browser.

Without mounting the data directory, the changes made using the docker container will not persist when the docker container is destroyed.
