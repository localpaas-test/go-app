# FROM crccheck/hello-world

############################################################
# Build backend
FROM golang:1.25-alpine AS builder

RUN apk update && \
    apk add --no-cache -U tzdata make build-base ca-certificates && \
    rm -rf /var/cache/apk/*

ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

WORKDIR /build
COPY . .

RUN make mod
RUN make build

############################################################
# Build a small image
FROM alpine:3.22
WORKDIR /app
RUN apk update && \
    apk add --no-cache ca-certificates make && \
    rm -rf /var/cache/apk/*

# For running app
COPY --from=builder /build/app .
COPY --from=builder /build/Makefile .

# Command to run
CMD ["sh","-c","./app"]
