FROM centos:7
MAINTAINER Brian Lee <briandl92391@gmail.com>

RUN yum -y update

RUN yum -y install epel-release

ADD https://github.com/brian-dlee/centos-equip/raw/master/equip.sh /root/equip.sh

# This depends on java so we don't need to explicitly install the java JDK
# Oracle Java 1.7 64-bit will be installed
RUN bash /root/equip.sh maven:3 tomcat:8

ADD https://github.com/geoserver/geoserver/archive/2.7.3.tar.gz /geoserver.2.7.3.tar.gz

RUN tar zxf /geoserver.2.7.3.tar.gz -C /opt/

RUN cd /opt/geoserver-2.7.3/src && \
    mvn clean install

RUN yum -y install unzip

RUN mkdir /var/lib/tomcat/webapps/geoserver
RUN mkdir -p /var/lib/geoserver/data
RUN unzip /opt/geoserver-2.7.3/src/web/app/target/geoserver.war -d /var/lib/tomcat/webapps/geoserver

ENV GEOSERVER_HOME=/var/lib/tomcat/webapps/geoserver
ENV GEOSERVER_DATA=/var/lib/geoserver/data

RUN chown -R tomcat:tomcat /var/lib/geoserver /var/lib/tomcat/webapps/geoserver && \
    chmod -R 770 /var/lib/geoserver /var/lib/tomcat/webapps/geoserver

RUN runuser -pu tomcat /usr/local/share/tomcat/bin/startup.sh

ENTRYPOINT ["/bin/bash"]
CMD []






#####
# RUN yum -y install gdal-java gdal netcdf-devel
#####
