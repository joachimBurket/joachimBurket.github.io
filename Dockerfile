FROM ruby:3.0-alpine

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN INSTALLED_PACKAGES="openssl-dev ruby-dev gcc g++ make" && \
    apk add --no-cache --virtual .build-deps $INSTALLED_PACKAGES &&\
    apk add --no-cache git

WORKDIR /usr/src/app

COPY Gemfile jekyll-text-theme.gemspec ./
RUN bundle install

# Deleting build dependencies
RUN apk del .build-deps

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "help"]
