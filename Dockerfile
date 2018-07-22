FROM debian:stretch-slim
MAINTAINER Nicolas de Marqué <nicolas.demarque@gmail.com>

WORKDIR /gluster-web

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y curl gnupg2 \
	&& curl -sL https://deb.nodesource.com/setup_8.x | bash - ; \
    apt-get install -y --no-install-recommends \
		sudo sshpass ruby \
		glusterfs-client nodejs \
		ruby-dev git make g++ libsqlite3-dev zlib1g zlib1g-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* \
    && npm install -g bower \
    && echo "gem: --no-rdoc --no-ri" > ~/.gemrc \
	&& gem install bundler \
	&& git clone https://github.com/oss2016summer/gluster-web-interface.git /gluster-web \
    && bower install --allow-root \
	&& bundle install \
	&& bin/rake db:migrate \
	&& rm -rf Gemfile.* ~/.gem ~/.bundle /usr/lib/ruby/gems/2.3.0/cache \
	&& apt-get remove --purge -y ruby-dev git make g++ libsqlite3-dev zlib1g-dev \
	&& apt-get autoremove --purge -y

COPY entrypoint /
EXPOSE 3000
ENTRYPOINT ["/entrypoint"]
