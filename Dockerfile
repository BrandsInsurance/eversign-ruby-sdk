FROM ruby:3.0.1

RUN apt-get update && apt-get install -y curl vim htop

ENV APP_PATH="Eversign"
WORKDIR /$APP_PATH

ENV LOCK_PATH="Locks"
RUN mkdir -p /$LOCK_PATH

COPY . /$APP_PATH

ENV BUNDLER_VERSION 2.3.18

RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle update
RUN mv Gemfile.lock /$LOCK_PATH/

RUN cp /$APP_PATH/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD /bin/bash
