FROM ruby:2.6.2

RUN apt-get update -qq && apt-get install -y nodejs yarn sqlite3 libsqlite3-dev

RUN mkdir /app
WORKDIR /app

ENV BUNDLER_VERSION=2.0.2
RUN gem install bundler -v 2.0.2

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . ./app
