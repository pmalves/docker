FROM    ubuntu:14.04
ARG BOX_USER
ARG BOX_PASSWORD
ARG BOX_URL
ARG BRANCH
ARG BUILD
ARG PRODUCT
MAINTAINER  Pedro Alves <palves@pentaho.com>


# Set the locale

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV TERM xterm
RUN update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX && \
  echo Building for branch $BRANCH, buildno $BUILD, using source $BOX_USER@$BOX_URL 



# For jdk8, install oracle-java8-installer

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common unzip git lftp postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3  && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    rm -rf /tmp/*
    

ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD scripts/run.sh /pentaho/

RUN mkdir -p /pentaho/tmp && \
  lftp -c "lcd /pentaho/tmp; open -u $BOX_USER,$BOX_PASSWORD $BOX_URL ; cd $BRANCH/$BUILD; mget \ 
  biserver-$PRODUCT-$BRANCH-$BUILD.zip \
  paz-plugin-ee-$BRANCH-$BUILD.zip \
  pir-plugin-ee-$BRANCH-$BUILD.zip \
  pdd-plugin-ee-$BRANCH-$BUILD.zip \
  ; \
  cd /CI/DEV_LICENSES; \
  mget *.lic \
  "; \
  cd /pentaho && \
  unzip /pentaho/tmp/biserver-$PRODUCT-$BRANCH-$BUILD.zip -d . && \
  unzip /pentaho/tmp/paz-plugin-ee-$BRANCH-$BUILD.zip -dbiserver-ee/pentaho-solutions/system && \
  unzip /pentaho/tmp/pir-plugin-ee-$BRANCH-$BUILD.zip -dbiserver-ee/pentaho-solutions/system && \
  unzip /pentaho/tmp/pdd-plugin-ee-$BRANCH-$BUILD.zip -dbiserver-ee/pentaho-solutions/system && \
  license-installer/install_license.sh install -q  /pentaho/tmp/*lic && \ 
  mv /root/.pentaho/.installedLicenses.xml /pentaho/biserver* && \ 
  echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf && \
  /etc/init.d/postgresql start && \
  cd /pentaho/biserver-ee/data/postgresql; \
  psql -U postgres -f create_jcr_postgresql.sql; \
  psql -U postgres -f create_quartz_postgresql.sql; \
  psql -U postgres -f create_repository_postgresql.sql; \
  rm /pentaho/biserver-ee/promptuser.sh; \
  touch /pentaho/biserver-ee/tomcat/logs/catalina.out ; \
  touch /pentaho/biserver-ee/tomcat/logs/pentaho.log ; \
  sed -i -e 's/\(exec ".*"\) start/\1 run/' /pentaho/biserver-ee/tomcat/bin/startup.sh; \
  mkdir /home/pentaho && groupadd -r pentaho && useradd -r -g pentaho -p $(perl -e'print crypt("pentaho", "aa")' ) -G sudo pentaho && \ 
  chown -R pentaho.pentaho /pentaho && \ 
  chown -R pentaho.pentaho /home/pentaho

WORKDIR /pentaho
USER pentaho


EXPOSE 8080 8044 9001

# 1. Run 

ENTRYPOINT ["bash", "/pentaho/run.sh"]

