FROM golang:1.15.2-alpine as builder

ENV GOPATH=/go \
    GO111MODULE=on \
    PROJECT_ROOT=/go/src/github.com/istsh/pipecd-sample-app

WORKDIR $PROJECT_ROOT

RUN wget https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/v0.3.2/grpc_health_probe-linux-amd64 -O grpc_health_probe && \
    chmod +x grpc_health_probe

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o pipecd-sample-cli -a ./app/cmd/cli
RUN CGO_ENABLED=0 GOOS=linux go build -o pipecd-sample-proxy -a ./app/cmd/reverse-proxy
RUN CGO_ENABLED=0 GOOS=linux go build -o pipecd-sample-server -a ./app/cmd/server

# image for release
FROM gcr.io/distroless/base:latest
ENV BUILDER_ROOT /go/src/github.com/istsh/pipecd-sample-app
ENV PROJECT_ROOT /
COPY --from=builder $BUILDER_ROOT/pipecd-sample-cli $PROJECT_ROOT/pipecd-sample-cli
COPY --from=builder $BUILDER_ROOT/pipecd-sample-proxy $PROJECT_ROOT/pipecd-sample-proxy
COPY --from=builder $BUILDER_ROOT/pipecd-sample-server $PROJECT_ROOT/pipecd-sample-server
COPY --from=builder $BUILDER_ROOT/grpc_health_probe /bin/grpc_health_probe
