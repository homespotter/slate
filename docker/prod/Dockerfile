FROM ruby:2.6-slim

RUN apt-get update
RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

ADD . /srv/slate/
WORKDIR /srv/slate

RUN apt-get install -y --no-install-recommends \
        build-essential \
        nodejs \
    && gem install bundler \
    && bundle install \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /srv/slate/slate.sh
RUN npm install -g serve

RUN ./slate.sh build
