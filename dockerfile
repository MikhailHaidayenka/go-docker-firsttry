FROM golang:1.18-alpine as builder
RUN apk add git

RUN GOCACHE=OFF

WORKDIR /go/test
COPY . .

ENV CGO_ENABLED 0
RUN go build -o tapp main.go

FROM alpine
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /root/
COPY --from=builder /go/test/tapp .
CMD ["./tapp"]