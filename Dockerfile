FROM ubuntu:14.04
MAINTAINER Philippe Blanc

RUN apt-get update \
	&& apt-get install -y apt-transport-https ca-certificates \
	&& apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
	&& echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list \
	&& apt-get update \
	&& apt-get install -y vim docker-engine make perl cpanminus \
	&& cpanm Text::Template \
	&& cpanm URI \
	&& cpanm Switch \
	&& cpanm File::Which \
	&& apt-get remove -y make cpanminus \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./res/s88c /opt/s88c
COPY ./res/bashrc.txt /root/.bashrc
COPY ./res/bash_aliases.txt /root/.bash_aliases
COPY ./res/entrypoint /root/entrypoint

RUN chmod +x /opt/s88c/s88c.pl && chmod +x /root/entrypoint && chown -R root:root /opt/s88c

# Set the time zone to the local time zone
RUN echo "America/New_York" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /var/www
ENTRYPOINT ["/root/entrypoint"]
