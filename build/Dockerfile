FROM golang:1.22.0-alpine3.19 as go

WORKDIR /go/src/app

COPY . .

CMD ["app"]

ENV GOFLAGS="-buildvcs=false"

RUN apk update \
    && apk add jq \
    && chmod +x /usr/bin/jq
