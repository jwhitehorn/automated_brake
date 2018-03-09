FROM debian:9-slim

RUN apt-get update
RUN apt-get install -y handbrake-cli ruby

RUN mkdir /etc/automated_brake
RUN mkdir /etc/automated_brake/to_encode
RUN mkdir /etc/automated_brake/encoded
RUN mkdir /tmp
COPY runner.rb /etc/automated_brake/
COPY settings.yml /etc/automated_brake/

WORKDIR /etc/automated_brake
CMD ruby /etc/automated_brake/runner.rb
