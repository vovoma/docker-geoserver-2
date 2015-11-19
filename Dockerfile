FROM centos:7
MAINTAINER Brian Lee <briandl92391@gmail.com>

RUN yum -y update
RUN yum -y install epel-release unzip

# This depends on java so we don't need to explicitly install the java JDK
# Oracle Java 1.7 64-bit will be installed
ADD https://github.com/brian-dlee/centos-equip/raw/master/equip.sh /root/equip.sh
RUN bash /root/equip.sh maven:3 tomcat:8

ADD https://github.com/geoserver/geoserver/archive/2.7.3.tar.gz /geoserver.2.7.3.tar.gz
RUN tar zxf /geoserver.2.7.3.tar.gz -C /opt/
RUN cd /opt/geoserver-2.7.3/src && \
    mvn clean install

RUN mkdir /var/lib/tomcat/webapps/geoserver
RUN mkdir -p /var/lib/geoserver/data
RUN unzip /opt/geoserver-2.7.3/src/web/app/target/geoserver.war -d /var/lib/tomcat/webapps/geoserver

ENV GEOSERVER_HOME=/var/lib/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=/var/lib/geoserver/data

RUN chown -R tomcat:tomcat /var/lib/geoserver /var/lib/tomcat/webapps/geoserver && \
    chmod -R 770 /var/lib/geoserver /var/lib/tomcat/webapps/geoserver

COPY scripts /opt/geoserver-startup-scripts

EXPOSE 8080

VOLUME ["/var/lib/geoserver/data", "/var/lib/tomcat/webapps/geoserver", "/var/log/tomcat"]

CMD ["/opt/geoserver-startup-scripts/geoserver-run.sh"]
