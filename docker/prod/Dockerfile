FROM ruby:2.6-slim

RUN apt-get update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

ADD . /srv/slate/
WORKDIR /srv/slate

RUN apt-get install -y --no-install-recommends \
  build-essential \
  nodejs \
  && gem install bundler -v 2.4.22 \
  && bundle install \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

RUN chmod +x /srv/slate/slate.sh
RUN npm install -g serve

RUN ./slate.sh build
