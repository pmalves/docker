FROM		ubuntu:14.04
MAINTAINER	Pedro Alves <palves@pentaho.com>


# Set the locale

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV TERM xterm
RUN update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX



# For jdk8, install oracle-java8-installer

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*



ADD biserver-ce-6.0.1.0-386.tar.gz /pentaho/
ADD scripts/run.sh /pentaho/

EXPOSE 8080 8044


RUN mkdir /home/pentaho && groupadd -r pentaho && useradd -r -g pentaho pentaho
RUN chown -R pentaho.pentaho /pentaho && chown -R pentaho.pentaho /home/pentaho

WORKDIR /pentaho
USER pentaho


RUN rm /pentaho/biserver-ce/promptuser.sh; \
		touch /pentaho/biserver-ce/tomcat/logs/catalina.out ; \
		touch /pentaho/biserver-ce/tomcat/logs/pentaho.log ; \
		sed -i -e 's/\(exec ".*"\) start/\1 run/' /pentaho/biserver-ce/tomcat/bin/startup.sh; 

ENTRYPOINT ["bash", "/pentaho/run.sh"]

