FROM ruby:2.1.5-slim
ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=C.UTF-8

RUN apt-get update -y && \
   apt-get install -y \
   build-essential \
   libssl-dev \
   libyaml-dev \
   git-core \
   libpq-dev \
   libxml2-dev \
   libxslt1-dev \
   libcurl3 \
   libcurl3-gnutls \
   libcurl4-openssl-dev \
   pkg-config

RUN gem install bundler

ENV APP_DIR=/code

WORKDIR $APP_DIR
ADD Gemfile $APP_DIR
ADD Gemfile.lock $APP_DIR
RUN bundle

ADD . $APP_DIR
ADD .build_info $APP_DIR/public/.build_info
ADD .build_info $APP_DIR

RUN rake assets:precompile

CMD /bin/bash

# CMD bundle exec rails server -b 0.0.0.0 -p $APP_PORT
# CMD bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:3000

