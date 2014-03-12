FROM ubuntu:precise

MAINTAINER Vilius Lukosius <vilius.lukosius@teliasonera.com>

#set-up java, extracted version needs to be present @ resources folder.
ADD tmp/jdk1.6.0_26 /usr/lib/jvm/jdk1.6.0_26

RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.6.0_26/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.6.0_26/bin/javac" 1
RUN update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.6.0_26/bin/javaws" 1

ENV JAVA_HOME /usr/lib/jvm/jdk1.6.0_26

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# install sshd and supervisor
RUN apt-get install -y openssh-server supervisor

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

ADD supervisor/sshd.conf   /etc/supervisor/conf.d/sshd.conf

# add public key for passwordless auth
ADD ssh_keys/id_rsa_docker.pub /tmp/id_rsa_docker.pub
RUN mkdir -p /root/.ssh
RUN cat /tmp/id_rsa_docker.pub >> /root/.ssh/authorized_keys

#clean-up
RUN rm /tmp/id_rsa_docker.pub
RUN apt-get clean

expose 22

CMD ["/usr/bin/supervisord", "-n"]