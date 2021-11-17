FROM ruby:3.0.2-alpine3.14

WORKDIR /action
COPY Gemfile Gemfile.lock /action/
RUN bundle install
COPY lib /action/lib

CMD ["ruby", "/action/lib/index.rb"]