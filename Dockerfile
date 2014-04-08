FROM ubuntu:12.04

MAINTAINER Ryan Kanno <ryankanno@localkinegrinds.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade

# install defaults
RUN apt-get install -qy build-essential curl git

# install supervisor // upgrade
RUN apt-get -y install python-pip && pip install --upgrade pip
RUN pip install supervisor

# install golang
RUN (curl -s https://go.googlecode.com/files/go1.2.1.src.tar.gz | tar -v -C /usr/local -xz)
RUN (cd /usr/local/go/src && ./make.bash --no-clean 2>&1)
ENV PATH /usr/local/go/bin:$PATH

# install ssh
RUN (apt-get -y install openssh-server && mkdir /var/run/sshd)

# install etcd
RUN git clone https://github.com/coreos/etcd.git /opt/etcd
RUN (cd /opt/etcd && ./build)

# configure
ADD ./etc/supervisor/etcd.conf /etc/supervisor/conf.d/etcd.conf
RUN mkdir -p /root/.ssh
ADD ./authorized_keys /root/.ssh/
RUN (chmod 700 /root && chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys)
RUN chown -R root /root

EXPOSE 22 4001 7001

CMD ["/usr/local/bin/supervisord","-n","-c","/etc/supervisor/conf.d/etcd.conf"]
