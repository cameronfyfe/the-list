FROM debian:buster

ARG PROFILE
COPY target/${PROFILE}/the-list-backend /usr/local/bin/

ENTRYPOINT ["the-list-backend"]
