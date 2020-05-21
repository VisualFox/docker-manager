FROM ubuntu:14.04
MAINTAINER Philippe Blanc

RUN apt-get update \
	&& apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
	&& echo deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable > /etc/apt/sources.list.d/docker.list \
	&& apt-get update \
	&& apt-get install -y vim docker-ce make perl cpanminus \
	&& cpanm Text::Template \
	&& cpanm URI \
	&& cpanm Switch \
	&& cpanm File::Which \
	&& apt-get remove -y make cpanminus \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./res/bashrc.txt /root/.bashrc
COPY ./res/bash_aliases.txt /root/.bash_aliases
COPY ./res/entrypoint /root/entrypoint

RUN git clone https://github.com/VisualFox/s88c.git /opt/s88c \
 && chmod +x /opt/s88c/s88c.pl \
 && chown -R root:root /opt/s88c \
 && chmod +x /root/entrypoint

# Set the time zone to the local time zone
RUN echo "America/New_York" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /var/www
ENTRYPOINT ["/root/entrypoint"]
