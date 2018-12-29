FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /acidlabs-test
WORKDIR /acidlabs-test
COPY Gemfile /acidlabs-test/Gemfile
COPY Gemfile.lock /acidlabs-test/Gemfile.lock
RUN bundle install
COPY . /acidlabs-test