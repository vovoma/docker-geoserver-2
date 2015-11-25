FROM centos:7
MAINTAINER Brian Lee <briandl92391@gmail.com>

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install unzip netcdf-devel gdal gdal-devel gdal-java

# This depends on java so we don't need to explicitly install the java JDK
# Oracle Java 1.7 64-bit will be installed
ADD https://github.com/brian-dlee/centos-equip/raw/master/equip.sh /root/equip.sh
RUN bash /root/equip.sh maven:3 tomcat:8

COPY geoserver-2.7.4.war.zip /opt/geoserver-2.7.4.war.zip
COPY plugins /opt/geoserver-2.7.4-plugins

RUN unzip /opt/geoserver-2.7.4.war.zip -d /opt/ && rm -f /opt/geoserver-2.7.4.war.zip

RUN unzip /opt/geoserver.war -d /var/lib/tomcat/webapps/geoserver
RUN rm -rf /var/lib/tomcat/webapps/ROOT
RUN ln -s /var/lib/tomcat/webapps/geoserver /var/lib/tomcat/webapps/ROOT
RUN eval 'for i in /opt/geoserver-2.7.4-plugins/*.zip; do unzip -n $i -d /var/lib/tomcat/webapps/geoserver/WEB-INF/lib/; done;'

RUN mkdir -p /var/lib/geoserver/data

ENV LD_LIBRARY_PATH "/usr/lib64:/usr/local/lib:/usr/lib/java/gdal"
ENV CATALINA_OPTS "-Xmx256M -Xms48m -XX:MaxPermSize=128m -server"
ENV GEOSERVER_HOME "/var/lib/tomcat/webapps/geoserver"
ENV GEOSERVER_DATA_DIR "/var/lib/geoserver/data"
ENV GEOSERVER_LOG_LOCATION "/var/log/tomcat/geoserver.log"

RUN chown -R tomcat:tomcat /var/lib/geoserver /var/lib/tomcat/webapps/geoserver && \
    chmod -R 770 /var/lib/geoserver /var/lib/tomcat/webapps/geoserver

EXPOSE 8080

VOLUME ["/var/lib/geoserver/data/", "/var/lib/tomcat/webapps/geoserver/", "/var/log/tomcat/"]

CMD ["/usr/local/share/tomcat/bin/catalina.sh", "run"]
