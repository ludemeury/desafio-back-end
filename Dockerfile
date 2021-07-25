FROM ruby:2.6.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN mkdir /app
WORKDIR /app

ENV BUNDLER_VERSION=2.0.2
RUN gem install bundler -v 2.0.2

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . ./app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
