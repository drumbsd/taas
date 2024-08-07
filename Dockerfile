# syntax=docker/dockerfile:1.2

FROM golang:1.22.6-alpine3.20 as mother

WORKDIR /src/

COPY . /src/
RUN apk add git --update && rm -rf /var/cache/apk/*
RUN go mod download && go mod verify
RUN CGO_ENABLED=0 go build -o /opt/taas

FROM scratch
COPY --from=mother /opt/taas /opt/taas
COPY insults.json /config/insults.json
EXPOSE 8080
WORKDIR /opt/
CMD ["./taas"]
