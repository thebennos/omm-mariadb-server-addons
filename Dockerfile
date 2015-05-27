
FROM ubuntu:latest
MAINTAINER Benjamin Wenderoth <b.wenderoth@gmail.com> 

# Install packages
RUN apt-get -qq -y install software-properties-common && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu trusty main' && \
    apt-get -y update && \
    apt-get -y install mariadb-server netcat

RUN apt-get clean && apt-get autoclean && apt-get -y autoremove

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN rm -rf /var/lib/mysql/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
CMD ["true"]


ENV AUTHORIZED_KEYS **None**

EXPOSE 22
Expose 3306
CMD ["/run.sh"]
