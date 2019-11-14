FROM alpine:3.8

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir /run/nginx

RUN apk update

RUN apk --update --no-cache add \
	nginx \
	curl
