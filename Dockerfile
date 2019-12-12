FROM ruby:2.6.1-alpine

RUN apk add --update \
  build-base \
  sqlite-dev \
  nodejs \
  tzdata \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  mariadb-dev \
  imagemagick \
  git \
  curl \
  && rm -rf /var/cache/apk/*
RUN cd /tmp && curl -Ls https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz | tar xz &&\
    cp -R lib lib64 / &&\
    cp -R usr/lib/x86_64-linux-gnu /usr/lib &&\
    cp -R usr/share /usr/share &&\
    cp -R etc/fonts /etc &&\
    curl -k -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -jxf - &&\
    cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

# RUN gem install rails -v 5.2.2
RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries
RUN gem install spree_cmd
# ENV GEM_HOME="/usr/local/bundle"
# ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

ENV myapp /myapp
RUN mkdir $myapp
WORKDIR $myapp

ADD . $myapp

CMD bundle check || bundle install

# CMD rails s -b 0.0.0.0
# CMD ["sh", "docker-entrypoint.sh"]
