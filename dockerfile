FROM golang:1.18-alpine as builder
RUN apk add git

RUN GOCACHE=OFF
RUN go env -w GOPRIVATE=github.com/mather-economics

WORKDIR /go/test
COPY . .

ARG ACCESS_TOKEN
ENV ACCESS_TOKEN=$ACCESS_TOKEN
#RUN git config --global url."https://rossmather:${CICD_GO_TOKEN}@github.com/mather-economics".insteadOf "https://github.com/mather-economics"
RUN git config --global url."https://mather-economics:${ACCESS_TOKEN}@github.com".insteadOf "https://github.com"

ENV CGO_ENABLED 0
RUN go build -o tapp main.go

FROM alpine
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /root/
COPY --from=builder /go/test/tapp .
CMD ["./tapp"]